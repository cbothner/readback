class SongsController < ApplicationController
  before_action :set_song, only: [:update, :destroy]
  layout "headline"

  # GET /songs
  # GET /songs.json
  def index
    @episode = Episode.includes(show: [:semester, :dj, episodes: [:dj, :show]]).find(params[:episode_id])
    #@songs = Song.all.sort_by(&:at).reverse
    @songs = @episode.songs
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
          #puts curl = "curl 'http://wcbn.org/ryan-playlist/enter.php' -H 'Cookie: SESS9104266d4868b70ba255f1bc149e4ede=eif98ajtcten6no92434jt1b15; SESSc285cabfaee1047a0c6146cbad182c06=j96la9iho4148r7l24ru9rg460; wcbn_loggedin=11895; quiet_cookie_ack=none' -H 'Origin: http://wcbn.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en-US;q=0.8,en;q=0.6,fr;q=0.4' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://wcbn.org/ryan-playlist/enter.php?' -H 'Connection: keep-alive' --data 'db%3Asongs%3Aadd_req%3Ashow_id=53663&db%3Asongs%3Aadd%3Ainstance_id=41351&db%3Asongs%3Aadd_req%3Aplaytime=#{Time.zone.now.strftime("%Y-%m-%d+%H%%3A%M%%3A%S")}&db%3Asongs%3Aadd_req%3Asonglength=00%3A02%3A00&db%3Asongs%3Aadd%3Aartist=#{@song.artist.gsub(' ', '+')}&db%3Asongs%3Aadd_req%3Atitle=#{@song.name.gsub(' ', '+')}&db%3Asongs%3Aadd%3Aalbum=#{@song.album.gsub(' ', '+')}&db%3Asongs%3Aadd%3Arlabel=#{@song.label.gsub(' ', '+')}&wcbn_instance_id=41351&wcbn_showends=2015-07-09+15%3A00%3A00&db%3Ashow_instance%3A41351%3Anotes=' --compressed"
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
                                   :year, :episode_id)
    end
end
