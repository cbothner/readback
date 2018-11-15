# frozen_string_literal: true

# We love music
class SongsController < ApplicationController
  before_action :set_song, only: %i[update destroy]
  layout 'headline'

  # GET /episodes/1/songs
  def index
    @episode = Episode.includes(:setbreaks,
                                show: [:semester, :dj, episodes: %i[dj show]])
                      .find(params[:episode_id])
    # @songs = Song.all.sort_by(&:at).reverse
    @songs = @episode.songs
    @songs += @episode.setbreaks
    @songs = @songs.sort_by(&:at)
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)
    @episode = Episode.includes(show: %i[semester dj]).find(params[:episode_id])
    @song.episode = @episode
    @song.at = if params[:override_episode] == 'true'
                 @song.episode.ending - 1.second
               else
                 Time.zone.now
               end

    respond_to do |format|
      if @song.at.between?(@song.episode.beginning, @song.episode.ending) ||
         params[:override_episode] == 'true'
        if @song.save
          format.html { redirect_to root_path }
          format.json { render :show, status: :created, location: @song }
        else
          format.html do
            flash[:error] = @song.errors.full_messages.to_sentence
            flash[:song] = @song
            redirect_to root_path
          end
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      else
        format.html do
          flash[:song] = @song
          flash[:confirm_episode] = true
          redirect_to root_path
        end
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    @song.update(song_params)
    respond_with_bip @song
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html do
        flash[:alert] = ['Song deleted']
        redirect_to playlist_path
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:name, :artist, :request, :album, :label,
                                 :year, :episode_id, :at, :local, :new)
  end
end
