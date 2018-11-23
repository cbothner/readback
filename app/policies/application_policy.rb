# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    superuser?
  end

  def show?
    superuser?
  end

  def create?
    superuser?
  end

  def new?
    create?
  end

  def update?
    superuser?
  end

  def edit?
    update?
  end

  def destroy?
    superuser?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  protected

  def superuser?
    user.has_cached_role? :superuser
  end
end
