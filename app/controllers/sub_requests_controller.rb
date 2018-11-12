# frozen_string_literal: true

# @see SubRequest
class SubRequestsController < ApplicationController
  before_action :authenticate_dj!
  before_action :set_sub_request, only: %i[show update destroy]
  before_action :set_episode, only: %i[new create]

  authorize_actions_for SubRequest, except: %i[new create]

  decorates_assigned :sub_request

  # GET /sub_requests
  def index
    set_sub_requests
  end

  def show; end

  def new
    build_sub_request
    authorize_action_for @sub_request
  end

  def create
    @sub_request = @episode.sub_requests.build sub_request_params
    authorize_action_for @sub_request

    if @sub_request.save
      redirect_to sub_requests_path, successfully_created
    else
      render :new
    end
  end

  def update
    authorize_action_for @sub_request

    if @sub_request.update sub_request_params
      redirect_to @sub_request, successfully_updated
    else
      render :show
    end
  end

  def destroy
    authorize_action_for @sub_request
    @sub_request.destroy
    redirect_to dj_upcoming_episodes_path(@sub_request.episode.dj),
                successfully_destroyed
  end

  private

  def set_sub_requests
    sub_requests = SubRequest.send(request_scope)
                             .includes(episode: [show: %i[dj semester]])
                             .reject { |req| req.episode.past? }
                             .select { |req| req.updatable_by?(current_dj) }

    @sub_requests = SubRequestsDecorator.decorate(sub_requests)
  end

  def set_episode
    @episode = Episode.find(params[:episode_id])
  end

  def request_scope
    if params[:request_scope] == 'fulfilled' && current_dj.has_role?(:superuser)
      return :fulfilled
    end

    :unfulfilled
  end
  helper_method :request_scope

  def set_sub_request
    @sub_request = SubRequest.includes(episode: %i[dj show]).find(params[:id])
  end

  def build_sub_request
    @sub_request = @episode.sub_requests.build
    return unless @episode.show.is_a? SpecialtyShow

    @sub_request.group = @episode.show.hosts - [current_dj]
  end

  def sub_request_params
    params.require(:sub_request).permit(:status, :reason, group: [])
  end
end
