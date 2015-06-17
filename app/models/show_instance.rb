class ShowInstance < ActiveRecord::Base
  belongs_to :show, polymorphic: true
  belongs_to :dj
  has_many :songs

  def self.on_air
    where(beginning: (Time.zone.now - 6.hours)..Time.zone.now).order(:beginning).last
  end

  def self.starts_on_day (day)
    where(beginning: (day.at_beginning_of_day..day.tomorrow.at_beginning_of_day)).take
  end

  def past
    Time.zone.now > beginning
  end

  def at
    if Time.zone.now > ending
      ending
    else
      beginning
    end
  end

  def subbed_for?
    !dj.nil?
  end

  def time_string
    "#{beginning.strftime("%A, %B %-d, %Y &nbsp;%l:%M")} &ndash; #{ending.strftime("%l:%M%P")}".html_safe
  end
end
