class FreeformShowsController < ApplicationController
  include ShowsController

  before_action :set_freeform_show, only: [:show, :edit, :update, :destroy]
  before_action :define_params_method, only: [:create, :update]

  layout "headline"

  # GET /freeform_shows
  # GET /freeform_shows.json
  def index
    @freeform_shows = FreeformShow.all
  end

  # GET /freeform_shows/1
  # GET /freeform_shows/1.json
  def show
  end

  # GET /freeform_shows/new
  def new
    @freeform_show = FreeformShow.new
  end

  # GET /freeform_shows/1/edit
  def edit
  end

  # POST /freeform_shows
  # POST /freeform_shows.json
  def create
    @freeform_show = FreeformShow.new(freeform_show_params)
    @freeform_show.dj = Dj.find(params[:freeform_show][:dj_id])
    @freeform_show.semester = Semester.find(params[:semester_id])

    respond_to do |format|
      if @freeform_show.save
        @freeform_show.propagate
        format.html { redirect_to edit_semester_path(@freeform_show.semester) }
      else
        format.html do
          flash[:alert] = @freeform_show.errors.full_messages
          session[:freeform_show] = @freeform_show
          redirect_to edit_semester_path(params[:semester_id])
        end
      end
    end
  end

  # PATCH/PUT /freeform_shows/1
  # PATCH/PUT /freeform_shows/1.json
  def update
    respond_to do |format|
      if @freeform_show.update(freeform_show_params)
        format.html { redirect_to @freeform_show, notice: 'Freeform show was successfully updated.' }
        format.json { render :show, status: :ok, location: @freeform_show }
      else
        format.html { render :edit }
        format.json { render json: @freeform_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freeform_shows/1
  # DELETE /freeform_shows/1.json
  def destroy
    @freeform_show.destroy
    respond_to do |format|
      format.html { redirect_to freeform_shows_url, notice: 'Freeform show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_freeform_show
      @freeform_show = FreeformShow.find(params[:id])
      @show_instances = @freeform_show.show_instances
    end
end
