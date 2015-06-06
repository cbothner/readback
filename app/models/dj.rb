class Dj < ActiveRecord::Base
  has_and_belongs_to_many :specialty_shows
  has_many :freeform_shows
  has_many :show_instances
  
  serialize :roles, Array

  def semesters_count
    (freeform_shows.map(&:semester) + specialty_shows.map(&:semester))
      .uniq.count
  end

  def can_do_daytime_radio?
    semesters_count > 1
  end
end
