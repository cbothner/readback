json.dj_name "#{@dj}"
json.extract! @dj, :id, :real_name_is_public, :about, :website, :public_email
json.real_name @dj.real_name_is_public ? @dj.name : nil
json.shows @shows do |show, shows|
  json.name show
  json.semesters shows do |show|
    json.id show.id
    json.semester show.semester.season
    json.semester_beginning show.semester.beginning
    json.times show.time_string html: false
    json.one_beginning show.episodes.take.try :beginning
    json.one_ending show.episodes.take.try :ending
  end
end
