class EpisodesController < ApplicationController
  before_filter :authenticate_dj!, except: :show
  authorize_actions_for Episode, except: [:show, :index]
  before_action :set_episode, only: [:show, :update, :request_sub]
  layout "headline"

  def index
    sub_statuses = Episode.statuses.select{ |stat| stat[/needs_sub/] }
    episodes_needing_subs = Episode.where(status: sub_statuses.values)

    @requests_by_day = episodes_needing_subs.group_by do
      |ep| (ep.at - 6.hours).at_beginning_of_day
    end

    unless @requests_by_day.empty?
      start_of_week = Time.zone.now.at_beginning_of_day.at_beginning_of_week
      max = episodes_needing_subs.max_by(&:at).at.at_beginning_of_day
      @weeks = []
      while start_of_week < max do
        @weeks << start_of_week
        start_of_week +=  7.days
      end
    end

    render layout: "wide"
  end

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
