class DjAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def self.updatable_by?(user)
    true
  end
  def updatable_by?(user)
    resource == user || user.has_role?(:superuser)
  end

end
