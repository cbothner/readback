class Dj < ActiveRecord::Base
  has_and_belongs_to_many :specialty_shows
  has_many :freeform_shows
  has_many :show_instances
end
