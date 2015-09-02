class SpecialtyShowsController < ApplicationController
  include ShowsController

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
    authorize_action_for @specialty_show
  end

  # POST /specialty_shows
  # POST /specialty_shows.json
  def create
    coordinator = Dj.find(params[:specialty_show].delete(:coordinator_id))
    djs = Dj.find(params[:specialty_show].delete(:djs).reject(&:blank?))

    @specialty_show = SpecialtyShow.new(specialty_show_params)
    @specialty_show.coordinator = coordinator
    @specialty_show.djs = djs
    @specialty_show.semester = Semester.find(params[:semester_id])
    @specialty_show.set_times_conditionally_from_params params[:specialty_show]

    respond_to do |format|
      if @specialty_show.save
        format.html do
          #session[:specialty_show] = {
            #weekday: @specialty_show.weekday,
            #beginning: @specialty_show.ending
          #}
          redirect_to edit_semester_path(@specialty_show.semester, anchor: "tab-specialty")
        end
      else
        format.html do
          flash[:alert] = @specialty_show.errors.full_messages
          session[:specialty_show] = @specialty_show
          redirect_to edit_semester_path(params[:semester_id], anchor: "tab-specialty")
        end
      end
    end
  end

  # PATCH/PUT /specialty_shows/1
  # PATCH/PUT /specialty_shows/1.json
  def update
    authorize_action_for @specialty_show

    @specialty_show.coordinator = Dj.find(params[:specialty_show].delete(:coordinator_id))
    @specialty_show.djs = Dj.find(params[:specialty_show].delete(:djs).reject(&:blank?))
    @specialty_show.set_times_conditionally_from_params params[:specialty_show]

    respond_to do |format|
      if @specialty_show.update(specialty_show_params)
        format.html { redirect_to @specialty_show, notice: 'Specialty show was successfully updated.' }
        format.json { render :show, status: :ok, location: @specialty_show }
      else
        format.html { render :show }
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

  # PATCH/PUT /specialty_shows/1/deal
  #
  # This "deals" djs out to the show's episodes, setting up a standard rotation
  # of n hosts
  def deal
    respond_to do |format|
      if @specialty_show.deal
        format.html { redirect_to @specialty_show }
      end
    end
  end

  private
    def active_record_find_includes
      { episodes: [:dj] }
    end

    def specialty_show_params
      params.require(:specialty_show).permit(:name, :coordinator_id, :djs)
    end
end
