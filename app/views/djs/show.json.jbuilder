# frozen_string_literal: true

json.dj_name @dj.to_s
json.extract! @dj, :id, :real_name_is_public, :about, :website, :public_email
json.image_url dj_profile_url @dj, variant: { thumbnail: '320x320^' }
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

    json.semester show.semester.decorate.season
    json.semester_beginning show.semester.beginning
  end
end
