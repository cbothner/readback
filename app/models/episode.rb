class Episode < ActiveRecord::Base
  include Authority::Abilities

  enum status: [:unassigned, :normal, :confirmed, :needs_sub_in_group,
                :needs_sub, :needs_sub_including_nighttime_djs, :overridden]
  serialize :sub_request_group

  belongs_to :show, polymorphic: true
  belongs_to :dj
  belongs_to :trainee
  has_many :songs, dependent: :restrict_with_exception
  has_many :sub_requests, dependent: :destroy

  def self.on_air
    where(beginning: (Time.zone.now - 6.hours)..Time.zone.now).order(:beginning).last
  end

  def self.starts_on_day (day)
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

  def subbed_for?
    confirmed? || ((needs_sub? || needs_sub_including_nighttime_djs?) && (dj != show.dj))
  end

  def date_string
    "#{beginning.strftime("%A, %B %-d, %Y")}".html_safe
  end

  def just_time_string(html: true)
    dash = html ? ' &ndash; '.html_safe : ' -- '
    "#{beginning.strftime("%l:%M")}#{dash}#{ending.strftime("%l:%M%P")}"
      .html_safe
  end

  def time_string
    date_string + "<span style=\"display:inline-block\">&nbsp;&nbsp;&nbsp;#{just_time_string}</span>".html_safe
  end

  def active_dj
    dj || show.dj
  end

  def nighttime?
    beginning.hour.between?(0,5)
  end

  def status_string
    case status
    when 'unassigned' then 'Unassigned'
    when 'normal' then "#{dj}"
    when 'confirmed' then "#{dj} &#x2713;".html_safe
    when /needs_sub/ then "#{dj}"
    when 'overridden' then "Overridden!"
    end
  end
end
