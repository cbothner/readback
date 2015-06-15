module Show
  UNIMPORTANT_DATE = DateTime.parse "January 23, 1972"

  def propagate
    days = semester.range.to_enum.select { |x| x.wday == self.weekday }
    days.each do |d|
      bbb = d.change(beginning.to_datetime.hms)
      eee = d.change(ending.to_datetime.hms)
      if show_instances.select {|x| x.beginning.at_noon == d.at_noon}.empty?
        show_instances.create(beginning: bbb, ending: eee)
      end
    end
  end

  def sort_times t
    {sortable: ((send(t) - 6.hours).seconds_since_midnight),
     printable: (send(t).strftime '%l:%M %P')}
  end
end

class DateTime
  def hms
    {hour: hour, minute: minute, second: second}
  end
end
