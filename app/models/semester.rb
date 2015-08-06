class Semester < ActiveRecord::Base
  has_many :freeform_shows, dependent: :destroy
  has_many :specialty_shows, dependent: :destroy
  has_many :talk_shows, dependent: :destroy
  validates :beginning, :ending, presence: true
  include Authority::Abilities

  def self.current
    where("beginning < ?", Time.zone.now).order(beginning: :desc).first
  end

  def range
    beginning.to_datetime..ending.to_datetime
  end

  def weeks
    range.count / 7
  end

  def start
    beginning.strftime "%B %-d, %Y"
  end

  def season
    beginning.strftime "%B %Y"
  end

  def end
    ending.strftime "%B %-d, %Y"
  end

  def future?
    Time.zone.now < beginning
  end

end
