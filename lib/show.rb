module Show
  UNIMPORTANT_DATE = Time.zone.parse "January 23, 1972"

  def most_recent_episode
    episodes.where("beginning < ?", Time.zone.now).order(beginning: :desc).first
  end

  def propagate
    offset = (0..6).include?(beginning.hour) ? 1 : 0
    days = semester.range.to_enum.select { |x| (x - offset.days).wday == self.weekday }
    days.each do |d|
      d = d.in_time_zone
      bbb = d.change(beginning.hms)
      eee = d.change(ending.hms)
      if episodes.starts_on_day(d).nil?
        ep = episodes.create(beginning: bbb, ending: eee, status: default_status)
      end
    end
    self
  end

  def unambiguous_name
    name
  end

  def time_string
    "<span style=\"display:inline-block\">(#{["Sunday", "Monday", "Tuesday",
                                             "Wednesday", "Thursday", "Friday",
                                             "Saturday"][weekday]}s,
    #{beginning.strftime("%l:%M")} &ndash; #{
        ending.strftime("%l:%M%P")})</span>".html_safe
  end

  def sort_times t
    {sortable: ((send(t) - 6.hours).seconds_since_midnight),
     printable: (send(t).strftime '%l:%M %P')}
  end
end

class Time
  def hms
    {hour: hour, min: min, sec: sec}
  end
end
