class EpisodesController < ApplicationController
  authorize_actions_for Episode, except: :show
  before_action :set_episode, only: [:show, :update, :request_sub]
  layout "headline"

  # GET /episodes/1
  # GET /episodes/1.json
  def show
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    authorize_action_for @episode
    @episode.status = :confirmed
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
        format.json { respond_with_bip @episode }
      else
        format.html { render :edit }
        format.json { respond_with_bip @episode }
      end
    end
  end

  def request_sub
    authorize_action_for @episode
    first_level_sub_request = if @episode.show.is_a? SpecialtyShow
                                :needs_sub_in_group
                              else
                                :needs_sub
                              end

    @episode.status = case @episode.status
                      when 'normal', 'confirmed' then first_level_sub_request
                      when 'needs_sub_in_group' then :needs_sub
                      when 'needs_sub' then :needs_sub_including_nighttime_djs
                      end

    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode.show, notice: 'Sub request placed.' }
      else
        format.html { render :show }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:dj_id, :notes)
    end
end
