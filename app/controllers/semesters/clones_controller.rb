module Semesters
  class ClonesController < ApplicationController
    before_action :authenticate_dj!
    authorize_actions_for Semester

    layout 'headline'

    # GET /semesters/new
    def new
      @model = find_semester(params.delete(:semester_id)).decorate
      @semester = Semester.new beginning: @model.ending
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
          format.json do
            render json: @semester.errors, status: :unprocessable_entity
          end
        end
      end
    end

    private

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
end
