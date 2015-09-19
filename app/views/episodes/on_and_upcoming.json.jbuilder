json.css  stylesheet_url 'application', media: 'all'

json.html (render partial: "upcoming_episodes", formats: [:html], locals: {limit: 3}).gsub "href=\"/", "href=\"http://wcbn-readback.herokuapp.com/"

json.show do
  json.name @on_air.show.unambiguous_name
  json.dj @on_air.dj.to_s
  json.times @on_air.just_time_string
end
