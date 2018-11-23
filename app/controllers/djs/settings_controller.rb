# frozen_string_literal: true

module Djs
  class SettingsController < ApplicationController
    before_action :authenticate_dj!

    def edit
      authorize Dj, :create?

      @settings = build_settings
    end

    def update
      authorize Dj, :create?

      @settings = build_settings
      @settings.assign_attributes settings_params
      @settings.save

      redirect_to edit_dj_settings_path(@settings.dj), successfully_updated
    end

    private

    def build_settings
      dj = Dj.preload(:roles).find(params[:dj_id])
      Dj::Settings.new dj: dj
    end

    def settings_params
      params.require(:dj_settings).permit!
    end
  end
end
