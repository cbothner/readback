class FreeformShowsController < ApplicationController
  include ShowsController

  # GET /freeform_shows/1
  # GET /freeform_shows/1.json
  def show; end

  # POST /freeform_shows
  # POST /freeform_shows.json
  def create
    @freeform_show = FreeformShow.new(freeform_show_params)
    @freeform_show.dj_id = params[:freeform_show][:dj_id]
    @freeform_show.semester_id = params[:semester_id]

    @freeform_show.set_times_conditionally_from_params params[:freeform_show]

    respond_to do |format|
      if @freeform_show.save
        format.html do
          # session[:freeform_show] = {
          #   weekday: @freeform_show.weekday,
          #   beginning: @freeform_show.ending
          # }
          redirect_to edit_semester_path(@freeform_show.semester)
        end
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
    authorize_action_for @freeform_show

    unless params[:freeform_show][:dj_id].nil?
      @freeform_show.dj_id = params[:freeform_show][:dj_id]
    end
    @freeform_show.set_times_conditionally_from_params params[:freeform_show]

    respond_to do |format|
      if @freeform_show.update(freeform_show_params)
        format.html { redirect_to @freeform_show, notice: 'Freeform show was successfully updated.' }
        format.json { render :show, status: :ok, location: @freeform_show }
      else
        format.html { render :show }
        format.json { render json: @freeform_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freeform_shows/1
  # DELETE /freeform_shows/1.json
  def destroy
    @freeform_show.destroy
    respond_to do |format|
      format.html { redirect_to edit_semester_path(@freeform_show.semester), notice: 'Freeform show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def active_record_find_includes
    { episodes: [:dj, show: [:dj]] }
  end
end
