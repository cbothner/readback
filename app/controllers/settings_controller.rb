class SettingsController < ApplicationController
  before_action :authenticate_dj!
  authorize_actions_for Setting

  def create
    @setting = Setting.new new_setting_params

    if @setting.save
      render json: @setting
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  def update
    @setting = Setting.find(params[:id])

    if @setting.update existing_setting_params
      render json: @setting
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  private
  def new_setting_params
    params.require(:setting).permit(:key, :value)
  end

  def existing_setting_params
    params.require(:setting).permit(:value)
  end
end
