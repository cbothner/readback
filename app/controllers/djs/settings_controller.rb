# frozen_string_literal: true

module Djs
  class SettingsController < ApplicationController
    before_action :authenticate_dj!

    def edit
      @settings = build_settings
    end

    def update
      @settings = build_settings
      @settings.assign_attributes settings_params
      @settings.save
      redirect_to edit_dj_settings_path @settings.dj
    end

    private

    def build_settings
      dj = Dj.preload(:roles).find(params[:dj_id])
      Dj::Settings.new dj: dj
    end

    def settings_params
      params.require(:dj_settings).permit(
        :active, :stage_one_trainer, :superuser
      )
    end
  end
end
