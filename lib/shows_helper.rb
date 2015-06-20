module ShowsHelper
  def link_to_most_recent_episode(show)
    if show.most_recent_episode
      link_to show.name, episode_songs_path(show.most_recent_episode)
    else
      show.name
    end
  end

  def format_time(t)
    t.try {strftime("%H:%M")}
  end
end
