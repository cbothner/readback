class SetbreaksController < ApplicationController
  before_action :set_setbreak, only: [:update, :destroy]

  # POST /setbreaks
  # POST /setbreaks.json
  def create
    @setbreak = Setbreak.new(at: Time.zone.now)
    @setbreak.episode = Episode.on_air

    respond_to do |format|
      if @setbreak.save
        format.html { redirect_to playlist_path }
        format.json { render :show, status: :created, location: @setbreak }
      else
        format.html { render :new }
        format.json { render json: @setbreak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /setbreaks/1
  # PATCH/PUT /setbreaks/1.json
  def update
    respond_to do |format|
      if @setbreak.update(setbreak_params)
        format.json { respond_with_bip @setbreak }
      else
        format.json { respond_with_bip @setbreak }
      end
    end
  end

  # DELETE /setbreaks/1
  # DELETE /setbreaks/1.json
  def destroy
    @setbreak.destroy
    respond_to do |format|
      format.html { redirect_to playlist_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setbreak
      @setbreak = Setbreak.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setbreak_params
      params.require(:setbreak).permit(:at)
    end
end
