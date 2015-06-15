class Semester < ActiveRecord::Base
  has_many :freeform_shows
  has_many :specialty_shows
  has_many :talk_shows
  validates :beginning, presence: true

  def self.current
    where("beginning < ?", Time.now).order(beginning: :desc).first
  end

  def range
    beginning.to_datetime..ending.to_datetime
  end
  def start
    beginning.strftime "%B %-d, %Y"
  end
  def end
    ending.strftime "%B %-d, %Y"
  end

end
