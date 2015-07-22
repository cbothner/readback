class Episode < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'OwnedModelAuthorizer'

  enum status: [:unassigned, :normal, :confirmed, :needs_sub_in_group,
                :needs_sub, :needs_sub_including_nighttime_djs, :overridden]

  belongs_to :show, polymorphic: true
  belongs_to :dj
  has_many :songs

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

  def time_string
    date_string + "<span style=\"display:inline-block\">#{beginning.strftime("&nbsp;&nbsp;&nbsp;%l:%M")} &ndash; #{ending.strftime("%l:%M%P")}</span>".html_safe
  end

  def active_dj
    dj || show.dj
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
