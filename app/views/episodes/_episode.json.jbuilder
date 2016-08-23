json.name episode.show.name
json.dj episode.dj.to_s
json.dj_url url_for episode.dj
json.beginning episode.beginning
json.ending episode.ending
json.times episode.just_time_string
json.show_notes episode.notes
json.songs episode.songs.order(at: :desc) do |song|
  json.at song.at
  json.artist song.artist
  json.name song.name
  json.request song.request
  json.album song.album
  json.label song.label
  json.year song.year
end
json.semester_id episode.show.semester.id
