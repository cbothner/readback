json.new_from @from - 3.hours
json.new_til @from
json.items @past_items do |item|
  json.html render partial: item.to_partial_path,
    formats: [:html],
    locals: { item.class.to_s.underscore.to_sym => item }

  if item.is_a? Song
    json.extract! item, :at, :artist, :name, :request, :album, :label, :year
   end
end
