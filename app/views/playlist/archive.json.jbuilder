json.newfrom @from - 1.hour
json.newtil @from
json.items @past_items do |item|
  json.html render partial: item.to_partial_path,
    formats: [:html],
    locals: { item.class.to_s.underscore.to_sym => item }
end
