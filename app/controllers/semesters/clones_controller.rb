# frozen_string_literal: true

module Semesters
  # Create a new semester by copying some shows from a previous one
  class ClonesController < ApplicationController
    before_action :authenticate_dj!
    before_action :set_model
    authorize_actions_for Semester

    layout 'headline'

    # GET /semesters/1/clone/new
    def new
      @semester = Semester.new beginning: @model.ending
    end

    # POST /semesters/1/clone
    def create
      show_types_to_copy = JSON.parse params.delete(:shows_to_copy)
      @semester = Semester.create(semester_params)

      return render :new if @semester.errors.any?

      SemesterClonerJob.perform_later show_types_to_copy,
                                      into_semester: @semester
      redirect_to edit_semester_path @semester
    end

    private

    def set_model
      @model = find_semester(params.delete(:semester_id)).decorate
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
end
