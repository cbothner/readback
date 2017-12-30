class SemestersController < ApplicationController
  before_action :authenticate_dj!, except: %i[index show]
  authorize_actions_for Semester, except: %i[index show]

  before_action :set_semesters, only: %i[show]
  before_action :set_semester, only: %i[show edit update destroy]
  before_action :set_model, only: %i[new create]

  layout 'headline'

  # GET /semesters
  # GET /semesters.json
  def index
    redirect_to Semester.current
  end

  # GET /semesters/1
  # GET /semesters/1.json
  def show
    render layout: 'wide_with_sidebar'
  end

  # GET /semesters/new
  def new
    @semester = Semester.new beginning: @model.ending
  end

  # GET /semesters/1/edit
  def edit
    @freeform_show = @semester.freeform_shows.build
    @specialty_show = @semester.specialty_shows.build
    @talk_show = @semester.talk_shows.build
  end

  # POST /semesters
  # POST /semesters.json
  def create
    show_types_to_copy = JSON.parse params.delete(:shows_to_copy)
    @semester = Semester.create(semester_params)

    if @semester.errors.empty?
      SemesterClonerJob.perform_later show_types_to_copy,
                                      into_semester: @semester
    end

    respond_to do |format|
      if @semester.errors.empty?
        format.html { redirect_to edit_semester_path @semester }
        format.json { render :show, status: :created, location: @semester }
      else
        format.html { render :new }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semesters/1
  # PATCH/PUT /semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semesters/1
  # DELETE /semesters/1.json
  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to semesters_url, notice: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_semesters
    @semesters = Semester.all.decorate
  end

  def set_semester
    @semester = find_semester(params[:id]).decorate
  end

  def set_model
    @model = find_semester(params.delete(:model_id)).decorate
  end

  def find_semester(id)
    Semester
      .includes(talk_shows: [:dj],
                freeform_shows: [:dj],
                specialty_shows: %i[dj djs])
      .find(id)
  end

  def semester_params
    params.require(:semester).permit(:beginning, :ending)
  end
end
