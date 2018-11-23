# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def create?
    super || user.has_role?(:editor)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
