json.array!(@djs) do |dj|
  json.extract! dj, :id
  json.url dj_url(dj, format: :json)
end
