json.array!(@specialty_shows) do |specialty_show|
  json.extract! specialty_show, :id
  json.url specialty_show_url(specialty_show, format: :json)
end
