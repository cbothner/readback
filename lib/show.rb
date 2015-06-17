module Show
  UNIMPORTANT_DATE = Time.zone.parse "January 23, 1972"

  def propagate
    offset = (0..6).include?(beginning.hour) ? 1 : 0
    days = semester.range.to_enum.select { |x| (x - offset.days).wday == self.weekday }
    days.each do |d|
      d = d.in_time_zone
      bbb = d.change(beginning.hms)
      eee = d.change(ending.hms)
      if show_instances.starts_on_day(d).nil?
        show_instances.create(beginning: bbb, ending: eee)
      end
    end
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
