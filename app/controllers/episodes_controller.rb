class EpisodesController < ApplicationController
  before_action :authenticate!, except: [:index, :on_and_upcoming]
  authorize_actions_for Episode, except: [:index, :on_and_upcoming]
  before_action :set_episode, only: [:edit, :update]

  def index
    @dj = Dj.includes(episodes: [:sub_requests, show: [:dj, :semester]]).find(params[:dj_id])
    episodes = @dj.episodes.order(beginning: :desc).reject { |x| x.show.semester.future? }
    @future_episodes = episodes.reject(&:past?).reverse
    @past_episodes_by_semester = (episodes - @future_episodes).group_by { |x| x.show.semester }
  end

  def edit
    authorize_action_for @episode
    render layout: 'headline'
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    authorize_action_for @episode
    @episode.status = :confirmed
    respond_to do |format|
      if @episode.update(episode_params)
        format.html do
          path = if params[:episode].include?(:shadowed)
                   root_path 
                 else 
                   episode_songs_path(@episode)
                 end
          redirect_to path, notice: 'Episode was successfully updated.'
        end
        format.json { respond_with_bip @episode }
      else
        format.html { render :edit }
        format.json { respond_with_bip @episode }
      end
    end
  end

  def on_and_upcoming
    @standalone = true
    @on_air = Episode.on_air
    @future_episodes = Episode.includes(:dj, show: [:dj])
      .where(beginning: Time.zone.now..10.hours.since)
      .order(beginning: :asc)

    # For Tony's scraper
    @escaped_show_name = Rack::Utils.escape("#{@on_air.show.name} with #{@on_air.dj}") if params[:escaped_show_name]

    respond_to do |format|
      format.html do
        render layout: 'iframe'
      end
      format.json do
        render(text: @escaped_show_name)&& return if @escaped_show_name
        render
      end
    end

    expires_in 2.minutes, :public => true
    fresh_when last_modified: @on_air.beginning, public: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:dj_id, :notes, :shadowed)
    end

    def authenticate!
      if playlist_editor_signed_in?
        authenticate_playlist_editor!
      else
        authenticate_dj!
      end
    end
end
