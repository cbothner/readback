# frozen_string_literal: true

class TraineesController < ApplicationController
  before_action :authenticate_dj!, except: %i[show edit update]
  authorize_actions_for Trainee, only: %i[index new create]
  before_action :set_trainee, only: %i[show edit update destroy]

  # GET /trainees
  # GET /trainees.json
  def index
    @trainees = Trainee.includes(:episodes).where(disqualified: false)
                       .reject { |t| t.broadcasters_exam.accepted? }
                       .sort_by { |t| sortable(t) }
                       .reverse

    respond_to do |format|
      format.html
      format.csv do
        filename = "wcbn-trainees-#{Time.zone.now.strftime '%F'}"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  # GET /trainees/1
  # GET /trainees/1.json
  def show
    authorize_action_for @trainee

    episodes = @trainee.episodes
    @apprenticeships = {}
    sched = episodes.reject(&:past?)
    happened = (episodes - sched)
               .reject { |e| e.shadowed == false }
               .sort_by(&:beginning)
    @apprenticeships[:stage_two_training] = if happened.empty?
                                              []
                                            else
                                              [happened.shift]
                                            end
    @apprenticeships[:freeform_apprenticeships] = happened.select do |ep|
      ep.show.is_a? FreeformShow
    end
    @apprenticeships[:specialty_apprenticeships] = happened.select do |ep|
      ep.show.is_a? SpecialtyShow
    end
    # this is last for order in the view
    @apprenticeships[:scheduled_apprenticeships] = sched
  end

  # GET /trainees/new
  def new
    @trainee = Trainee.new
  end

  # GET /trainees/1/edit
  def edit
    authorize_action_for @trainee
  end

  # POST /trainees
  # POST /trainees.json
  def create
    @trainee = Trainee.new(trainee_params)

    respond_to do |format|
      if @trainee.save
        format.html do
          redirect_to action: 'new', notice: 'Got it! Welcome to WCBN'
        end
        format.json { render :show, status: :created, location: @trainee }
      else
        format.html { render :new }
        format.json do
          render json: @trainee.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /trainees/1
  # PATCH/PUT /trainees/1.json
  def update
    authorize_action_for @trainee

    respond_to do |format|
      if @trainee.update(trainee_params)
        format.html do
          redirect_to @trainee, notice: 'Trainee was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @trainee }
      else
        format.html { render :edit }
        format.json do
          render json: @trainee.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trainee
    @trainee = Trainee.includes(episodes: [:show]).find(params[:id])
  end

  def trainee_params
    params.require(:trainee).permit(:name, :phone, :email, :umid,
                                    :um_affiliation, :um_dept, :experience,
                                    :referral, :interests, :statement,
                                    :disqualified)
  end

  def sortable(t)
    if params[:sort] == 'progress'
      # t.volunteer_hours +
      (t.demotape.accepted? ? 10 : 0) +
        (100 * t.episodes.count)
    else
      t.created_at
    end
  end
end
