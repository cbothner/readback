weekday_names = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                 "Saturday", "Sunday"]

json.extract! @semester, :beginning, :ending

json.shows do
  1.upto 7 do |w|
    json.set! w, @semester.shows.select{|x| x.weekday == w % 7}.sort_by(&:beginning) do |show|
      json.id show.id
      json.name show.unambiguous_name
      json.description show.description
      json.dj do                            # Deprecated
        json.id show.dj.id                  # Deprecated
        json.name show.dj.to_s              # Deprecated
      end                                   # Deprecated
      json.djs show.djs do |d|
        json.id d.id
        json.name d.to_s
      end
      # This makes the request too slow.
      #json.episodes show.episodes.sort_by(&:beginning).select(&:past?) do |ep|
        #json.id ep.id
        #json.date ep.beginning
        #json.songs "#{ep.songs.count}"
      #end
      json.with show.with
      json.beginning show.beginning
      json.ending show.ending
      json.times show.time_string
      json.on_air show == Episode.on_air.show
    end
  end
end
