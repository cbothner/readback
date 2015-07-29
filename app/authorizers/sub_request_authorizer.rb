class SubRequestAuthorizer < ApplicationAuthorizer

  def self.readable_by? (user)
    user.active
  end

  def self.updatable_by? (user)
    user.active
  end

  def updatable_by? (user)
    return true if user.has_role? :superuser

    unless resource.confirmed?
      unless resource.needs_sub_including_nighttime_djs?
        return true if user.can_create?(SubRequest, for: resource.episode)
      end
      return false if resource.status_changed?
    end

    return true if resource.needs_sub_including_nighttime_djs?

    unless user.allowed_to_do_daytime_radio?
      return false unless resource.episode.nighttime?
    end

    if resource.needs_sub_in_group?
      return false unless resource.group.include? user.id
    end

    true
  end

  def self.creatable_by?(user, options)
    return false unless user.active
    ep = options[:for]
    ep.dj == user || ep.show.dj == user || user.has_role?(:superuser)
  end

  def deletable_by?(user)
    resource.episode.dj == user || user.has_role?(:superuser)
  end

end
