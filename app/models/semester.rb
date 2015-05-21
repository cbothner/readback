class Semester < ActiveRecord::Base
  has_many :freeform_shows
  has_many :specialty_shows
  has_many :talk_shows

  def self.current
    where(beginning: maximum("beginning")).first
  end

end
