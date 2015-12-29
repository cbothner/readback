class SongsController < ApplicationController

  before_action :set_song, only: [:update, :destroy]
  layout "headline"

  # GET /songs/find.json
  def find
    artist_name = params[:artist]
    song_title = "#{params[:name]}%"
    case_transformation = artist_name.case

    results = Song
      .where{ artist =~ artist_name }
      .where{ name =~ song_title }
      .where.not(album: nil, label: nil, year: nil)
      .order(at: :desc)
      .pluck(:name, :album, :label, :year)

    results.map! do |r|
      r.map! &:to_s
      unless r.first.case == case_transformation
        r.map! &case_transformation
      end
      r
    end

    results.map! do |r|
      {name: r[0], album: r[1], label: r[2], year: r[3]}
    end

    respond_to do |format|
      format.json { render json: results.uniq }
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
