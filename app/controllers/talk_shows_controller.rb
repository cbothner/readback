# frozen_string_literal: true

class TalkShowsController < ApplicationController
  include ShowsController

  # GET /talk_shows/1
  # GET /talk_shows/1.json
  def show; end

  # POST /talk_shows
  # POST /talk_shows.json
  def create
    @talk_show = TalkShow.new(talk_show_params)
    @talk_show.dj = Dj.find(params[:talk_show][:dj_id]) unless params[:talk_show][:dj_id].blank?
    @talk_show.semester = Semester.find(params[:semester_id])
    @talk_show.set_times_conditionally_from_params params[:talk_show]

    respond_to do |format|
      if @talk_show.save
        format.html do
          redirect_to edit_semester_path(@talk_show.semester,
                                         anchor: 'tab-talk')
        end
      else
        format.html do
          flash[:alert] = @talk_show.errors.full_messages
          session[:talk_show] = @talk_show
          redirect_to edit_semester_path(params[:semester_id],
                                         anchor: 'tab-talk')
        end
      end
    end
  end

  # PATCH/PUT /talk_shows/1
  # PATCH/PUT /talk_shows/1.json
  def update
    authorize_action_for @show

    set_show_dj_from_params
    set_show_times_from_params

    if @show.update talk_show_params
      redirect_to @show, successfully_updated
    else
      render :show
    end
  end

  # DELETE /talk_shows/1
  # DELETE /talk_shows/1.json
  def destroy
    @talk_show.destroy
    respond_to do |format|
      format.html { redirect_to edit_semester_path(@talk_show.semester), notice: 'Talk show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def talk_show_params
    params.require(:talk_show).permit(:name, :topic, :description, :website)
  end
end
