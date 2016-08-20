json.dj_name "#{@dj}"
json.extract! @dj, :id, :real_name_is_public, :image_url, :about, :website, :public_email
json.real_name @dj.real_name_is_public ? @dj.name : nil
json.shows @shows do |show_name, shows|
  json.name show_name
  json.semesters shows do |show|
      json.url url_for show
      json.name show.unambiguous_name
      json.description show.description
      json.website show.website
      json.djs show.hosts do |d|
        json.url url_for d
        json.name d.to_s
      end
      json.with show.with
      json.beginning show.beginning
      json.ending show.ending

      json.semester show.semester.season
      json.semester_beginning show.semester.beginning
  end
end
