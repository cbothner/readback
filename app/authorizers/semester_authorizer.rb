class SemesterAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
    user.has_role?(:superuser)
  end

  def readable_by?(user)
    !resource.future? || user.has_role?(:superuser)
  end

end
