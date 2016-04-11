json.url url_for @talk_show
json.name @talk_show.unambiguous_name
json.description @talk_show.description
json.website @talk_show.website
json.djs @talk_show.hosts do |d|
  json.url url_for d
  json.name d.to_s
end
json.episodes @talk_show.episodes.sort_by(&:beginning) do |ep|
  json.partial! "episodes/episode", episode: ep
end
json.with @talk_show.with
json.beginning @talk_show.beginning
json.ending @talk_show.ending
