module Show
  extend ActiveSupport::Concern

  included do
    belongs_to :semester
    has_many :episodes, as: :show, dependent: :destroy

    include Authority::Abilities
    self.authorizer_name = 'OwnedModelAuthorizer'
    
    validates :name, presence: true
  end

  include Recurring

  def most_recent_episode
    episodes.select { |ep| ep.beginning < Time.zone.now }
      .sort_by(&:beginning).last
  end

  #def propagate
    #offset = (0..5).include?(beginning.hour) ? 1 : 0
    #days = semester.range.to_enum.select { |x| (x - offset.days).wday == self.weekday }
    #days.each do |d|
      #d = d.in_time_zone
      #bbb = d.change(beginning.hms)
      #eee = d.change(ending.hms)
      #eee += 1.day if bbb > eee
      #if episodes.starts_on_day(d).nil?
        #ep = episodes.create(beginning: bbb, ending: eee, status: default_status, dj: dj )
      #end
    #end
    #self
  #end

  def set_times(weekday:, hour:, minute:)
    times = IceCube::Schedule.new(semester.beginning)
    times.add_recurrence_rule(
      IceCube::Rule
      .weekly
      .day(weekday)
      .hour_of_day(hour)
      .minute_of_hour(minute)
      .until(semester.ending)
    )
  end

  def unambiguous_name
    name
  end

  def time_string
    "<span style=\"display:inline-table\">(#{["Sunday", "Monday", "Tuesday",
                                             "Wednesday", "Thursday", "Friday",
                                             "Saturday"][weekday]}s,
    #{beginning.strftime("%l:%M")} &ndash; #{
        ending.strftime("%l:%M%P")})</span>".html_safe
  end

  def sort_times t
    {sortable: ((send(t) - 6.hours).seconds_since_midnight),
     printable: (send(t).strftime '%l:%M %P')}
  end

  def beginning
    times.first
  end
  
  def ending
    beginning + duration.hours
  end

  def weekday
    (times.first.wday - ( (0...6).include?(beginning.hour) ? 1 : 0 )) % 7
  end

  private
  def instance_collection_name
    "episodes"
  end

  def instance_params(t)
    {beginning: t, ending: t + duration.hours, status: default_status, dj: dj}
  end

end

class Time
  def hms
    {hour: hour, min: min, sec: sec}
  end
end
