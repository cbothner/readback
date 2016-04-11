json.url url_for @specialty_show
json.name @specialty_show.unambiguous_name
json.description @specialty_show.description
json.website @specialty_show.website
json.djs @specialty_show.hosts do |d|
  json.url url_for d
  json.name d.to_s
end
json.episodes @specialty_show.episodes.sort_by(&:beginning) do |ep|
  json.partial! "episodes/episode", episode: ep
end
json.with @specialty_show.with
json.beginning @specialty_show.beginning
json.ending @specialty_show.ending
