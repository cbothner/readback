module Show
  UNIMPORTANT_DATE = Date.parse "January 23, 1972"

  def sort_times t
    {sortable: ((send(t) - 6.hours).seconds_since_midnight),
     printable: (send(t).strftime '%l:%M %P')}
  end
end

