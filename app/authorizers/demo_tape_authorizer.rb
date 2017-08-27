class DemoTapeAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user == resource.trainee
  end

  def updatable_by?(user)
    return false unless resource.created_at == resource.updated_at
    user.has_role?(:training_coordinator) || super
  end
end
