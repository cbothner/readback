class SubRequestsController < ApplicationController
  before_filter :authenticate_dj!
  authorize_actions_for SubRequest
  before_action :set_sub_request, only: [:show, :update, :delete]

  # GET /sub_requests
  def index
    sub_requests = SubRequest.where(status: (0..2))
      .includes( episode: [show: [:dj]] )
      .select {|req| req.updatable_by?(current_dj)}

    @requests_by_day = sub_requests.group_by do
      |req| req.episode.at.at_beginning_of_day
    end

    unless @requests_by_day.empty?
      start_of_week = Time.zone.now.at_beginning_of_day.at_beginning_of_week
      max = sub_requests.max_by(&:at).at.at_beginning_of_day
      @weeks = []
      while start_of_week < max do
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
    @episode = Episode.find(sub_request_params[:episode_id])
    @sub_request = @episode.sub_requests.build
    authorize_action_for(@sub_request, for: @episode)
  end

  def create
    @episode = Episode.find(sub_request_params[:episode_id])
    @sub_request = @episode.sub_requests.build(sub_request_params)
    authorize_action_for(@sub_request, for: @episode)

    respond_to do |format|
      if @sub_request.save
        format.html { redirect_to @episode.show, notice: 'Sub request placed.' }
      else
        format.html { render :show }
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
    end
    
    respond_to do |format|
      if ActiveRecord::Base.transaction do
                                          @sub_request.save
                                          @episode.save
                                        end
        format.html {redirect_to @episode.show,
                     notice: "You’ve signed up to cover for #{old_dj}!"}
      else
        format.html { render :show, notice: @sub_request.errors.full_messages }
      end
    end
  end

  private
  def commit_message_that_signifies_that_a_req_should_be_marked_fulfilled
    "Cover for this slot"
  end

  def set_sub_request
    @sub_request = SubRequest.find(params[:id])
    @episode = @sub_request.episode
  end

  def sub_request_params
    params.require(:sub_request).permit(:episode_id, :status, :reason, :group)
  end
end
