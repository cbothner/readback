class EpisodeAuthorizer < OwnedModelAuthorizer

  def updatable_by?(user)
    (resource == Episode.on_air && user.is_a?(PlaylistEditor)) || super
  end

end
