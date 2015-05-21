class Semester < ActiveRecord::Base
  has_many :freeform_shows
  has_many :specialty_shows
  has_many :talk_shows
end
