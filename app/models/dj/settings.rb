# frozen_string_literal: true

class Dj
  class Settings
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_accessor :dj
    attribute :active, :boolean
    attribute :superuser, :boolean
    attribute :stage_one_trainer, :boolean

    def initialize(attributes = {})
      super
      assign_attributes dj.slice dj_params.keys
      assign_attributes_from_dj_roles
    end

    def persisted?
      true
    end

    def save
      dj.update dj_params
      persist_roles
    end

    private

    def roles
      %i[stage_one_trainer superuser]
    end

    def dj_params
      { active: active }
    end

    def assign_attributes_from_dj_roles
      roles.each do |role|
        send :"#{role}=", dj.has_cached_role?(role)
      end
    end

    def persist_roles
      roles.each do |role|
        if send role
          dj.add_role role
        else
          dj.remove_role role
        end
      end
    end
  end
end
