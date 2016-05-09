json.extract! @dj, :id, :dj_name, :real_name_is_public, :about, :website, :public_email
json.real_name @dj.real_name_is_public ? @dj.name : nil
json.shows @shows do |show, shows|
  json.name show
  json.semesters shows do |show|
    json.id show.id
    json.semester show.semester.season
    json.times show.time_string html: false
  end
end
