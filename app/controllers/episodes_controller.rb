class EpisodesController < ApplicationController
  before_filter :authenticate_dj!, except: :show
  authorize_actions_for Episode, except: [:show, :index]
  before_action :set_episode, only: [:update]

  def index
    @dj = Dj.includes(episodes: [show: [:dj, :semester]]).find(params[:dj_id])
    episodes = @dj.episodes.order(beginning: :desc)
    @future_episodes = episodes.reject(&:past?).reverse
    @past_episodes_by_semester = (episodes - @future_episodes).group_by { |x| x.show.semester }
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
