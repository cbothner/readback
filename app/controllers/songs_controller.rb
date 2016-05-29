class SongsController < ApplicationController

  before_action :set_song, only: [:update, :destroy]
  layout "headline"

  # GET /songs/find.json
  def find
    query = "(artist ILIKE :artist_name)" +
            "AND (#{params[:name].nil? ? "TRUE" : "name ILIKE :song_title"})" +
            "AND (#{params[:album].nil? ? "TRUE" : "album ILIKE :album_name"})" +
            "AND (album IS NOT NULL) AND (album != '')" +
            "AND (label IS NOT NULL) AND (label != '')"
    results = Song
      .where(query, {
          artist_name: "#{params[:artist]}%",
          song_title: "#{params[:name]}%",
          album_name: "#{params[:album]}%"
        })
      .order(at: :desc)

    case_transformation = params[:artist].case

    results = results.map do |r|
      unless r.name.case == case_transformation
        r = r.as_json
        r.each_pair do |key, val|
          r[key] = val.send case_transformation if val.is_a? String
        end
        r
      else
        r.as_json
      end
    end

    if !params[:name].nil?
      fields = %w(name album label year local)
    elsif !params[:album].nil?
      fields = %w(album label year local)
    else
      fields = %w(artist)
    end

    results.map! do |r|
      r.slice *fields
    end

    results.group_by &:itself

    respond_to do |format|
      format.json do
        render json: results
          .each_with_object(Hash.new(0)) { |o, h| h[o] += 1  }
          .sort_by { |k, v| -v  }
          .map(&:first)[0..4]
      end
    end
  end

  # GET /songs
  # GET /songs.json
  def index
    @episode = Episode.includes(:setbreaks, show: [:semester, :dj, episodes: [:dj, :show]]).find(params[:episode_id])
    #@songs = Song.all.sort_by(&:at).reverse
    @songs = @episode.songs
    @songs += @episode.setbreaks
    @songs = @songs.sort_by(&:at)
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)
    @episode = Episode.includes(show: [:semester, :dj]).find(params[:episode_id])
    @song.episode = @episode
    @song.at = unless params[:override_episode] == 'true'
                 Time.zone.now
               else
                 @song.episode.ending - 1.second
               end

    respond_to do |format|
      if (@song.at.between?( @song.episode.beginning, @song.episode.ending ) ||
          params[:override_episode] == 'true')
        if @song.save
          format.html { redirect_to controller: :playlist, action: :index }
          format.json { render :show, status: :created, location: @song }
        else
          format.html {
            flash[:alert] = @song.errors.full_messages
            session[:song] = @song
            redirect_to controller: :playlist, action: :index }
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      else
        format.html {
          session[:song] = @song
          session[:confirm_episode] = true
          redirect_to controller: :playlist, action: :index
        }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.json { respond_with_bip @song }
      else
        format.json { respond_with_bip @song }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html {
        flash[:alert] = ["Song deleted"]
        redirect_to controller: :playlist, action: :index
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :artist, :request, :album, :label,
                                   :year, :episode_id, :at, :local, :new)
    end
end
