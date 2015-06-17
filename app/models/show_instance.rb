class ShowInstance < ActiveRecord::Base
  belongs_to :show, polymorphic: true
  belongs_to :dj
  has_many :songs

  def self.on_air
    where(beginning: (Time.now - 6.hours)..Time.now).order(:beginning).last
  end

  def self.starts_on_day (day)
    where(beginning: (day.at_beginning_of_day..day.tomorrow.at_beginning_of_day)).take
  end

  def at
    if Time.now > ending
      ending
    else
      beginning
    end
  end

  def subbed_for?
    !dj.nil?
  end

  def time_string
    "#{beginning.getlocal.strftime("%A, %B %-d, %Y &nbsp;%l:%M")} &ndash; #{show.ending.getlocal.strftime("%l:%M%P")}".html_safe
  end
end
