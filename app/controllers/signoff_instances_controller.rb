class SignoffInstancesController < ApplicationController

  layout "headline"

  # GET /signoff_instances
  # GET /signoff_instances.json
  def index
    @signoff_instances = SignoffInstance.where.not(signed: nil).order(at: :desc)
  end

  def public_affairs_logs
    @til = params[:til] || Time.zone.now
    @from = params[:from] || Time.zone.now - 3.months

    @episodes = Episode
      .where(show_type: "TalkShow").where(ending: @from..@til)
      .where.not(notes: "")
      .order(ending: :desc)
  end

  # PATCH/PUT /signoff_instances/1
  # PATCH/PUT /signoff_instances/1.json
  def update
    authenticate_playlist_editor!
    @signoff_instance = SignoffInstance.find(params[:id])
    @signoff_instance.at = Time.zone.now
    respond_to do |format|
      if @signoff_instance.update(signoff_instance_params)
        format.html { redirect_to controller: :playlist, action: :index }
        format.js {}
      else
        format.html {
          flash[:alert] = @signoff_instance.errors.full_messages
          redirect_to controller: :playlist, action: :index
        }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def signoff_instance_params
      params.require(:signoff_instance).permit(:signed, :cart_name)
    end
end
