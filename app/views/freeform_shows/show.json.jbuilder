json.url url_for @freeform_show
json.name @freeform_show.unambiguous_name
json.description @freeform_show.description
json.website @freeform_show.website
json.djs @freeform_show.hosts do |d|
  json.url url_for d
  json.name d.to_s
end
json.episodes @freeform_show.episodes.sort_by(&:beginning) do |ep|
  json.partial! "episodes/episode", episode: ep
end
json.with @freeform_show.with
json.beginning @freeform_show.beginning
json.ending @freeform_show.ending
