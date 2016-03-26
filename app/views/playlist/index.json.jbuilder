json.on_air do
  json.name @on_air.show.name
  json.dj @on_air.dj.to_s
  json.times @on_air.just_time_string
  json.show_notes @on_air.notes
  json.songs @on_air.songs.order(at: :desc) do |song|
    json.at song.at
    json.artist song.artist
    json.name song.name
    json.request song.request
    json.album song.album
    json.label song.label
    json.year song.year
  end
end

json.upcoming_episodes @future_episodes do |ep|
  json.name ep.show.name
  json.dj ep.dj.to_s
  json.times ep.just_time_string
end
