json.on_air do
  json.partial! "episodes/episode", episode: @on_air
end

json.upcoming_episodes @future_episodes do |ep|
  json.name ep.show.name
  json.dj ep.dj.to_s
  json.times ep.just_time_string
end
