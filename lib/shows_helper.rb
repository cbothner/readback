module ShowsHelper
  def link_to_most_recent_episode(show)
    return link_to(show.name, show) if dj_signed_in? && current_dj.can_update?(Semester)
    if show.most_recent_episode
      link_to show.name, episode_songs_path(show.most_recent_episode)
    else
      show.name
    end
  end

  def format_time(t)
    t.try {strftime("%H:%M")}
  end

  def request_link(ep)
    case ep.status
    when 'normal', 'confirmed' then
      if current_dj.can_request?(ep)
        (link_to "Request Substitute", request_sub_episode_path(ep), method: :put)
      end
    when 'needs_sub_in_group' then "Sub requested from other rotating hosts."
    when 'needs_sub' then "Sub requested!"
    when 'needs_sub_including_nighttime_djs' then "Sub requested without restrictions."
    end
  end

end
