class AboutController < ApplicationController
  before_action :set_about

  def index; end

  def edit; end

  def update
    redirect_to action: 'index' if @about.update(about_params)
  end

  private

  def set_about
    @about = About.last
  end

  def about_params
    params.require(:about).permit(:description)
  end
end
