class OwnedModelAuthorizer < ApplicationAuthorizer

  def self.updatable_by?(user)
    true
  end
  def updatable_by?(user)
    resource.dj == user || user.has_role?(:superuser)
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
