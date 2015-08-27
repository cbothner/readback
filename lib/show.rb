module Show
  extend ActiveSupport::Concern

  included do
    belongs_to :semester
    has_many :episodes, as: :show, dependent: :destroy

    include Authority::Abilities
    self.authorizer_name = 'OwnedModelAuthorizer'
    
    validates :name, :times, :duration, presence: true

    after_create :propagate
    after_update :propagate_if_changed
  end

  include Recurring

  def propagate_if_changed
    byebug
    if times_changed? || duration_changed?
      episodes.reject(&:past?).each(&:destroy)
      propagate
    elsif dj_id_changed?
      episodes.normal.each do |ep|
        ep.update_attributes(dj_id: dj_id)
      end
    end
  end

  def most_recent_episode
    episodes.select { |ep| ep.beginning < Time.zone.now }
      .sort_by(&:beginning).last
  end

  def set_times_conditionally_from_params(params)
    wd = params[:weekday].to_i
    bg = Time.zone.parse params[:beginning]
    unless self.times && wd == self.times.first.wday &&
        bg.hour == self.times.first.hour && bg.min == self.times.first.min
      set_times weekday: wd, hour: bg.hour, minute: bg.min
    end
  end

  def set_times(weekday:, hour:, minute:)
    self.times = IceCube::Schedule.new(semester.beginning)
    self.times.add_recurrence_rule(
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
    times.try :first
  end
  
  def ending
    return nil unless beginning
    beginning + duration.hours
  end

  def weekday
    return 0 unless times
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
