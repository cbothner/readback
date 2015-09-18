class EpisodeAuthorizer < OwnedModelAuthorizer

  def updatable_by?(user)
    return true if (resource == Episode.on_air)

    return true if user.can_update? resource.show

    super
  end

end
