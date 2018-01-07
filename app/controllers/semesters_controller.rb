class SemestersController < ApplicationController
  before_action :authenticate_dj!, except: %i[index show]
  authorize_actions_for Semester, except: %i[index show]

  before_action :set_semesters, only: %i[show]
  before_action :set_semester, only: %i[show edit update destroy]

  layout 'headline'

  # GET /semesters
  def index
    redirect_to Semester.current
  end

  # GET /semesters/1
  def show
    render layout: 'wide_with_sidebar'
  end

  # GET /semesters/1/edit
  def edit
    @freeform_show = @semester.freeform_shows.build
    @specialty_show = @semester.specialty_shows.build
    @talk_show = @semester.talk_shows.build
  end

  private

  def set_semesters
    @semesters = Semester.all.decorate
  end

  def set_semester
    @semester = find_semester(params[:id]).decorate
  end

  def find_semester(id)
    Semester
      .includes(talk_shows: [:dj],
                freeform_shows: [:dj],
                specialty_shows: %i[dj djs])
      .find(id)
  end
end
