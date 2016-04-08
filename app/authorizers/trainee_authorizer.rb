class TraineeAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def self.creatable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

  def updatable_by?(user)
    user.has_role?(:stage_one_trainer) || user.has_role?(:superuser)
  end

end
