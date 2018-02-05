# frozen_string_literal: true

# @see SubRequest
class SubRequestsController < ApplicationController
  before_action :authenticate_dj!
  authorize_actions_for SubRequest, except: %i[new create]
  before_action :set_sub_request, only: %i[show update destroy]
  before_action :set_episode, only: %i[new create]

  # GET /sub_requests
  def index
    set_sub_requests
    render layout: 'wide'
  end

  def show
    render layout: 'thin'
  end

  def new
    @sub_request = @episode.sub_requests.build
    if @episode.show.is_a? SpecialtyShow
      @sub_request.group = @episode.show.hosts - [current_dj]
    end
    authorize_action_for @sub_request
    render layout: 'thin'
  end

  def create
    @sub_request = @episode.sub_requests.build(sub_request_params)
    authorize_action_for @sub_request

    if @sub_request.save
      redirect_to sub_requests_path, notice: 'Sub request placed.'
    else
      render :new
    end
  end

  def update
    authorize_action_for(@sub_request)

    if @sub_request.update sub_request_params
      redirect_to @sub_request, notice: 'Sub request was successfully updated.'
    else
      render :show, notice: @sub_request.errors.full_messages
    end
  end

  def destroy
    authorize_action_for @sub_request
    @sub_request.destroy
    redirect_to dj_episodes_path(current_dj),
                notice: 'Sub request was successfully deleted.'
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
    if params[:fulfilled] && current_dj.has_role?(:superuser)
      :fulfilled
    else
      :unfulfilled
    end
  end

  def set_sub_request
    @sub_request = SubRequest.includes(episode: %i[dj show]).find(params[:id])
  end

  def sub_request_params
    params.require(:sub_request).permit(:status, :reason, group: [])
  end
end
