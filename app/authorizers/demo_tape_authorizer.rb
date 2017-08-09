class DemoTapeAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user == resource.trainee
  end
end
