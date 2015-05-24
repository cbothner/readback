json.array!(@talk_shows) do |talk_show|
  json.extract! talk_show, :id
  json.url talk_show_url(talk_show, format: :json)
end
