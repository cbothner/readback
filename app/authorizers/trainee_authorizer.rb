class TraineeAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def readable_by?(user)
    return true if user == resource
    self.class.readable_by? user
  end

  def self.creatable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def self.updatable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def updatable_by?(user)
    return true if user == resource
    self.class.updatable_by? user
  end


end
