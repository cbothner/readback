class SubRequestsController < ApplicationController
  before_action :authenticate_dj!
  authorize_actions_for SubRequest, except: [:new, :create]
  before_action :set_sub_request, only: [:show, :update, :destroy]

  # GET /sub_requests
  def index
    request_statuses = (0..2)
    if params[:fulfilled] && current_dj.has_role?(:superuser)
      request_statuses = (3..3)
    end

    sub_requests = SubRequest.where(status: request_statuses)
      .includes( episode: [show: [:dj, :semester]] )
      .reject {|req| req.episode.past?}
      .select {|req| req.updatable_by?(current_dj)}

    @requests_by_day = sub_requests.group_by do
      |req| req.episode.at.at_beginning_of_day
    end

    unless @requests_by_day.empty?
      start_of_week = Time.zone.now.at_beginning_of_day.at_beginning_of_week
      max = sub_requests.max_by(&:at).at.at_beginning_of_day
      @weeks = []
      while start_of_week <= max do
        @weeks << start_of_week
        start_of_week +=  7.days
      end
    end

    render layout: "wide"
  end

  def show
    @fulfill_button_text = commit_message_that_signifies_that_a_req_should_be_marked_fulfilled
    render layout: 'thin'
  end

  def new
    @episode = Episode.find(params[:episode_id])
    @sub_request = @episode.sub_requests.build
    if @episode.show.is_a? SpecialtyShow
      @sub_request.group = @episode.show.hosts - [current_dj]
    end
    authorize_action_for(@sub_request, for: @episode)
    render layout: 'thin'
  end

  def create
    @episode = Episode.find(params[:episode_id])
    @sub_request = @episode.sub_requests.build(sub_request_params)
    authorize_action_for(@sub_request, for: @episode)

    @sub_request.group.reject! &:blank?
    @sub_request.status = @sub_request.group.empty? ? :needs_sub : :needs_sub_in_group

    respond_to do |format|
      if @sub_request.save
        @episode.status = @sub_request.status
        format.html { redirect_to sub_requests_path, notice: 'Sub request placed.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize_action_for(@sub_request)
    old_dj = @episode.dj
    if params[:commit] == commit_message_that_signifies_that_a_req_should_be_marked_fulfilled
      @episode.dj = current_dj
      @episode.status = :confirmed
      @sub_request.status = :confirmed
      success_args = [@episode.show, notice: "You’ve signed up to cover for #{old_dj}!"]
    else
      @episode.status = params[:sub_request][:status].to_sym
      @sub_request.status = params[:sub_request][:status].to_sym
      success_args = [@sub_request, notice: "The slot has been opened to all DJs."]
    end
    respond_to do |format|
      if ActiveRecord::Base.transaction do
        @episode.save
        @sub_request.save
      end
        format.html {redirect_to *success_args}
      else
        format.html { render :show, notice: @sub_request.errors.full_messages }
      end
    end
  end

  def destroy
    authorize_action_for(@sub_request)
    @sub_request.episode.confirmed!
    @sub_request.destroy
    respond_to do |format|
      format.html {
        redirect_to dj_episodes_path(current_dj), notice: 'Sub request was successfully deleted.'
      }
    end
  end

  private
  def commit_message_that_signifies_that_a_req_should_be_marked_fulfilled
    "Cover for this slot"
  end

  def set_sub_request
    @sub_request = SubRequest.includes(episode: [:dj, :show]).find(params[:id])
    @episode = @sub_request.episode
  end

  def sub_request_params
    params.require(:sub_request).permit(:status, :reason, group: [])
  end
end
