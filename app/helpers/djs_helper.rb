# frozen_string_literal: true

module DjsHelper
  def interest_link(name)
    '<input type="button" class="interest-link" data-interest="' + name + '" value="' +
      name + '" />'
  end

  def interest_links(list)
    list.map { |i| interest_link i }.join.html_safe
  end

  def needs_statement(trainee)
    trainee.um_affiliation == 'community' || !trainee.statement.blank?
  end

  def active_for_select(*selected_djs)
    active_djs = Dj.where(active: true).order(:name)
    selected = selected_djs.flatten.map { |dj| dj.try(:id) }
    puts "selected = #{selected}"
    options_from_collection_for_select(active_djs, :id, :name, selected)
  end

  def abbr(affil)
    case affil
    when 'community' then 'C.\@ A.'
    when 'student' then 'S.'
    when 'faculty' then 'F./S.'
    when 'alumnus' then 'A.'
    end
  end

  def roles_for_roster(dj)
    current_semester_shows = dj.shows.select { |x| x.semester == Semester.current }
    if current_semester_shows.empty?
      'Sub Only'
    else
      types = current_semester_shows
              .map { |x| x.class.name.underscore.humanize.titlecase }
              .uniq
      if types.length > 1
        (types.map { |x| x.split(' ').first } * ', ') + ' Shows'
      else
        types.first
      end
    end
  end

  def profile_picture(dj)
    content_tag :img, nil, class: ['profile-pic', ('robot' unless dj.avatar.attached?)], src: dj_profile_url(dj)
  end

  def dj_profile_url(dj, variant: { thumbnail: '128x128^' })
    return polymorphic_url dj.avatar.variant variant if dj.avatar.attached?

    dj.robot_picture_url
  end
end
