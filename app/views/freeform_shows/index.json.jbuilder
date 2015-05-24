json.array!(@freeform_shows) do |freeform_show|
  json.extract! freeform_show, :id
  json.url freeform_show_url(freeform_show, format: :json)
end
