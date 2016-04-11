weekday_names = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                 "Saturday", "Sunday"]

json.extract! @semester, :beginning, :ending

json.shows do
  1.upto 7 do |w|
    json.set! w, @semester.shows.select{|x| x.weekday == w % 7}.sort_by(&:beginning) do |show|
      json.url url_for show
      json.name show.unambiguous_name
      json.description show.description
      json.website show.website
      json.dj do                            # Deprecated
        json.id show.dj.id                  # Deprecated
        json.name show.dj.to_s              # Deprecated
      end                                   # Deprecated
      json.djs show.hosts do |d|
        json.url url_for d
        json.name d.to_s
      end
      json.with show.with
      json.beginning show.beginning
      json.ending show.ending
      json.on_air show == Episode.on_air.show
    end
  end
end
