weekday_names = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                 "Saturday", "Sunday"]

json.extract! @semester, :beginning, :ending

json.shows do
  1.upto 7 do |w|
    json.set! w, @semester.shows.select{|x| x.weekday == w % 7} do |show|
      json.id show.id
      json.name show.unambiguous_name
      json.dj do
        json.id show.dj.id
        json.name show.dj.to_s
      end
      json.beginning show.beginning
      json.ending show.ending
      json.on_air show == Episode.on_air.show
    end
  end
end
