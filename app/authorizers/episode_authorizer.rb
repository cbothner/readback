class EpisodeAuthorizer < OwnedModelAuthorizer

  def updatable_by?(user)
    can_add_episode_notes_on_air = (resource == Episode.on_air &&
                                    user.is_a?(PlaylistEditor))

    can_reassign_rotating_host = user.can_update? resource.show

    can_add_episode_notes_on_air || can_reassign_rotating_host || super
  end

end
