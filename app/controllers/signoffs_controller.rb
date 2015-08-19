class SignoffsController < ApplicationController
  before_filter :authenticate_dj!
  authorize_actions_for Signoff

  before_action :set_signoff, only: [:edit, :update]

  layout "headline"

  def index
    @signoffs = Signoff.all.sort
    @signoff = Signoff.new
  end

  def edit
    render layout: 'thin'
  end

  def update
    if params[:signoff][:random_interval]
    end
    respond_to do |format|
      if @signoff.update_attributes(signoff_params)
        format.html {redirect_to signoffs_path, notice: "Signoff successfully saved"}
      else
        format.html {render :edit}
      end
    end
  end

  private
  def set_signoff
    @signoff = Signoff.find(params[:id])
  end

  def signoff_params
    params.require(:signoff).permit(:on, :random, :times, :random_interval)
  end
end
