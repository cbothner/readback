class SpecialtyShowsController < ApplicationController
  include ShowsController

  before_action :set_specialty_show, only: [:show, :edit, :update, :destroy]
  before_action :define_params_method, only: [:create, :update]

  layout "headline"

  # GET /specialty_shows
  # GET /specialty_shows.json
  def index
    @specialty_shows = SpecialtyShow.all
  end

  # GET /specialty_shows/1
  # GET /specialty_shows/1.json
  def show
  end

  # GET /specialty_shows/new
  def new
    @specialty_show = SpecialtyShow.new
  end

  # GET /specialty_shows/1/edit
  def edit
  end

  # POST /specialty_shows
  # POST /specialty_shows.json
  def create
    @specialty_show = SpecialtyShow.new(specialty_show_params)
    @specialty_show.coordinator = Dj.find(params[:specialty_show].delete(:coordinator_id))
    @specialty_show.djs = Dj.find(params[:specialty_show][:djs])
    @specialty_show.semester = Semester.find(params[:semester_id])

    respond_to do |format|
      if @specialty_show.save
        @specialty_show.propagate
        format.html { redirect_to edit_semester_path(@specialty_show.semester) }
      else
        format.html do
          flash[:alert] = @specialty_show.errors.full_messages
          session[:specialty_show] = @specialty_show
          redirect_to edit_semester_path(params[:semester_id])
        end
      end
    end
  end

  # PATCH/PUT /specialty_shows/1
  # PATCH/PUT /specialty_shows/1.json
  def update
    @specialty_show.coordinator = Dj.find(params[:specialty_show].delete(:coordinator_id))
    @specialty_show.djs = Dj.find(params[:specialty_show].delete(:djs).reject(&:blank?))
    respond_to do |format|
      if @specialty_show.update(specialty_show_params)
        format.html { redirect_to @specialty_show, notice: 'Specialty show was successfully updated.' }
        format.json { render :show, status: :ok, location: @specialty_show }
      else
        format.html { render :edit }
        format.json { render json: @specialty_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specialty_shows/1
  # DELETE /specialty_shows/1.json
  def destroy
    @specialty_show.destroy
    respond_to do |format|
      format.html { redirect_to specialty_shows_url, notice: 'Specialty show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specialty_show
      @specialty_show = SpecialtyShow.find(params[:id])
      @episodes = @specialty_show.episodes
      @rotating_hosts = @specialty_show.djs.to_a << @specialty_show.coordinator
    end

    def specialty_show_params
      params.require(:specialty_show).permit(
        :name, :coordinator_id, :weekday, :ending, :beginning
      )
    end
end
