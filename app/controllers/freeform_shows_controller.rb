# frozen_string_literal: true

class FreeformShowsController < ApplicationController
  include ShowsController

  # GET /freeform_shows/1
  # GET /freeform_shows/1.json
  def show; end

  # POST /freeform_shows
  # POST /freeform_shows.json
  def create
    @show = FreeformShow.new(freeform_show_params)
    @show.dj_id = params[:freeform_show][:dj_id]
    @show.semester_id = params[:semester_id]

    @show.set_times_conditionally_from_params params[:freeform_show]

    respond_to do |format|
      if @show.save
        format.html do
          # session[:freeform_show] = {
          #   weekday: @show.weekday,
          #   beginning: @show.ending
          # }
          redirect_to edit_semester_path(@show.semester)
        end
      else
        format.html do
          flash[:alert] = @show.errors.full_messages
          session[:freeform_show] = @show
          redirect_to edit_semester_path(params[:semester_id])
        end
      end
    end
  end

  # PATCH/PUT /freeform_shows/1
  # PATCH/PUT /freeform_shows/1.json
  def update
    authorize_action_for @show

    unless params[:freeform_show][:dj_id].nil?
      @show.dj_id = params[:freeform_show][:dj_id]
    end
    @show.set_times_conditionally_from_params params[:freeform_show]

    respond_to do |format|
      if @show.update(freeform_show_params)
        format.html { redirect_to @show, notice: 'Freeform show was successfully updated.' }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :show }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freeform_shows/1
  # DELETE /freeform_shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to edit_semester_path(@show.semester), notice: 'Freeform show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def active_record_find_includes
    { episodes: [:dj, show: [:dj]] }
  end
end
