class SignoffInstancesController < ApplicationController
  before_action :set_signoff_instance, only: [:show, :edit, :update, :destroy]

  # GET /signoff_instances
  # GET /signoff_instances.json
  def index
    @signoff_instances = SignoffInstance.all
  end

  # GET /signoff_instances/1
  # GET /signoff_instances/1.json
  def show
  end

  # GET /signoff_instances/new
  def new
    @signoff_instance = SignoffInstance.new
  end

  # GET /signoff_instances/1/edit
  def edit
  end

  # POST /signoff_instances
  # POST /signoff_instances.json
  def create
    @signoff_instance = SignoffInstance.new(signoff_instance_params)

    respond_to do |format|
      if @signoff_instance.save
        format.html { redirect_to @signoff_instance, notice: 'Signoff instance was successfully created.' }
        format.json { render :show, status: :created, location: @signoff_instance }
      else
        format.html { render :new }
        format.json { render json: @signoff_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signoff_instances/1
  # PATCH/PUT /signoff_instances/1.json
  def update
    @signoff_instance.at = Time.zone.now
    respond_to do |format|
      if @signoff_instance.update(signoff_instance_params)
        format.html { redirect_to controller: :playlist, action: :index }
      else
        format.html {
          flash[:alert] = @signoff_instance.errors.full_messages
          redirect_to controller: :playlist, action: :index
        }
      end
    end
  end

  # DELETE /signoff_instances/1
  # DELETE /signoff_instances/1.json
  def destroy
    @signoff_instance.destroy
    respond_to do |format|
      format.html { redirect_to signoff_instances_url, notice: 'Signoff instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signoff_instance
      @signoff_instance = SignoffInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signoff_instance_params
      params.require(:signoff_instance).permit(:signed)
    end
end
