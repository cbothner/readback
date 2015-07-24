class EpisodeAuthorizer < ApplicationAuthorizer

  def updatable_by?(user)
    resource.needs_sub_including_nighttime_djs? ||
      (resource.needs_sub? && resource.beginning.hour.between?(0,6)) ||
      (resource.needs_sub? && user.allowed_to_do_daytime_radio?) ||
      (resource.needs_sub_in_group? && resource.sub_request_group.include?(user.id)) ||
      user.has_role?(:superuser)
  end

  def self.requestable_by?(user)
    true
  end
  def requestable_by?(user)
    if resource.needs_sub?
      user.has_role? :superuser
    else
      resource.dj == user || resource.show.dj == user || user.has_role?(:superuser)
    end
  end

end
