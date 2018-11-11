# frozen_string_literal: true

class Episode < ActiveRecord::Base
  include Authority::Abilities

  enum status: %i[unassigned normal confirmed needs_sub_in_group
                  needs_sub needs_sub_including_nighttime_djs overridden]
  serialize :sub_request_group

  belongs_to :show, polymorphic: true
  belongs_to :dj
  belongs_to :trainee, optional: true
  has_many :songs, dependent: :restrict_with_exception
  has_many :sub_requests, dependent: :destroy
  has_many :setbreaks, dependent: :destroy

  def self.on_at(time)
    where(beginning: (time - 6.hours)..time).order(:beginning).last
  end

  def self.on_air
    on_at(Time.zone.now)
  end

  def self.starts_on_day(day)
    where(beginning: (day.at_beginning_of_day..day.tomorrow.at_beginning_of_day)).take
  end

  def past?
    Time.zone.now > beginning
  end

  def at
    if Time.zone.now > beginning
      ending
    else
      beginning
    end
  end

  def range
    beginning..ending
  end

  def reminder_email_time
    number_of_days_before = (0...6).cover?(beginning.hour) ? 2 : 1
    (beginning - number_of_days_before.days).at_beginning_of_day + 9.hours
  end

  def subbed_for?
    (confirmed? || needs_sub? || needs_sub_including_nighttime_djs?) && dj != show.dj
  end

  def date_string
    beginning.strftime('%A, %B %-d, %Y').to_s.html_safe
  end

  def just_time_string(html: true)
    dash = html ? '–'.html_safe : ' -- '
    "#{beginning.strftime('%l:%M')}#{dash}#{ending.strftime('%l:%M %p')}"
      .html_safe.delete ' '
  end

  def time_string
    date_string + "<span style=\"display:inline-block\">&nbsp;&nbsp;&nbsp;#{just_time_string}</span>".html_safe
  end

  def active_dj
    dj || show.dj
  end

  def nighttime?
    beginning.hour.between?(0, 5)
  end

  def status_string
    case status
    when 'unassigned' then 'Unassigned'
    when 'normal' then dj.to_s
    when 'confirmed' then "#{dj} &#x2713;".html_safe
    when /needs_sub/ then dj.to_s
    when 'overridden' then 'Overridden!'
    end
  end

  def dj_on_hook?
    unassigned? || SubRequest.where(episode: self).where.not(status: SubRequest.statuses[:confirmed]).any?
  end
end
