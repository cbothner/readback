class Semester < ActiveRecord::Base
  include Authority::Abilities
  has_many :freeform_shows, dependent: :destroy
  has_many :specialty_shows, dependent: :destroy
  has_many :talk_shows, dependent: :destroy

  validates :beginning, :ending, presence: true

  default_scope { order(beginning: :desc) }

  def self.current
    where('beginning < ?', Time.zone.now.noon).order(beginning: :desc).first ||
      last
  end

  def future?
    Time.zone.now < beginning
  end

  def range
    beginning.to_datetime..ending.to_datetime
  end

  def shows
    (freeform_shows + specialty_shows + talk_shows).select(&:on_schedule?)
  end

  def weeks
    range.count / 7
  end
end
