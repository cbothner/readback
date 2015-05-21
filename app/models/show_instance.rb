class ShowInstance < ActiveRecord::Base
  belongs_to :show, polymorphic: true
  belongs_to :dj
  has_many :songs

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

  def self.on_air
    where(beginning: (Time.now - 6.hours)..Time.now).order(:beginning).last
  end

  def time_string
    "#{beginning.getlocal.strftime("%A, %B %-d, %Y &nbsp;%l:%M")} &ndash; #{show.ending.getlocal.strftime("%l:%M%P")}".html_safe
  end
end
