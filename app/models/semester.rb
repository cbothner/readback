# frozen_string_literal: true

class Semester < ActiveRecord::Base
  include Authority::Abilities
  has_many :freeform_shows, dependent: :destroy
  has_many :specialty_shows, dependent: :destroy
  has_many :talk_shows, dependent: :destroy

  before_validation :ensure_beginning_and_ending_are_at_six_am

  validates :beginning, :ending, presence: true
  validate :discrete_semester_dates

  after_create { Signoff.propagate_all(beginning, ending) }

  default_scope { order(beginning: :desc) }

  def discrete_semester_dates
    if beginning > ending
      errors.add(:ending, 'must be later than start date')
      return
    end

    conflicts = Semester.where(
      'tsrange(beginning, ending) && tsrange(?, ?)',
      beginning, ending
    )
    return unless conflicts.any?
    errors.add(:base, 'semester dates conflict with another semester')
  end

  def self.current
    where('beginning < ?', Time.zone.now.noon).order(beginning: :desc).first ||
      last
  end

  def ensure_beginning_and_ending_are_at_six_am
    self.beginning = beginning.change(hour: 6, min: 0, sec: 0)
    self.ending = ending.change(hour: 5, min: 59, sec: 59)
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
