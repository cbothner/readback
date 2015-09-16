module SongsHelper
  def message_if_episode_has_no_songs(episode)
    if episode.songs.empty?
      Haml::Engine.new(
"%tr
  %td.instructions{colspan: 6}
    = \"There are no songs recorded for #{episode.show.unambiguous_name}\""
      ).render
    end
  end

  def just_time(time)
    time.strftime "%-l:%M %P"
  end
end
