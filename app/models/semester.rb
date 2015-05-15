class Semester < ActiveRecord::Base
  has_many :freeform_shows
  has_many :specialty_shows
end
