# frozen_string_literal: true

class DjPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role? :superuser
        scope.all
      else
        scope.active
      end
    end
  end

  def update?
    super || user == record
  end
end
