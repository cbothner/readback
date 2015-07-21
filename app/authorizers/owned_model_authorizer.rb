class OwnedModelAuthorizer < ApplicationAuthorizer

  def self.updatable_by?(user)
    true
  end
  def updatable_by?(user)
    resource.dj == user || user.has_role?(:superuser)
  end

end
