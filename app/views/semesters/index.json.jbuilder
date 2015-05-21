json.array!(@semesters) do |semester|
  json.extract! semester, :id
  json.url semester_url(semester, format: :json)
end
