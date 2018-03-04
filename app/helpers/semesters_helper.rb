# frozen_string_literal: true

module SemestersHelper
  def semesters_options
    options_from_collection_for_select(@semesters,
                                       ->(semester) { semester_path(semester) },
                                       :season,
                                       semester_path(@semester))
  end
end
