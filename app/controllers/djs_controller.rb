# frozen_string_literal: true

class DjsController < ApplicationController
  before_action :authenticate_dj!, except: :show
  authorize_actions_for Dj, only: %i[new create destroy]

  before_action :set_dj, only: %i[show edit update destroy]

  decorates_assigned :dj

  # GET /djs
  # GET /djs.json
  def index
    @djs = Dj.all.order(name: :asc)

    respond_to do |format|
      format.html do
        authorize_action_for Dj
      end
      format.pdf { @djs = @djs.select(&:active) }
      format.csv do
        @djs = @djs.select(&:active)
        filename = "wcbn-djs-#{Time.zone.now.strftime '%F'}"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  # GET /djs/1
  # GET /djs/1.json
  def show
    with_theme :lime if @dj.id == 1
  end

  # GET /djs/new
  def new
    @dj = Dj.new
  end

  # GET /djs/1/edit
  def edit
    authorize_action_for @dj
  end

  # POST /djs
  # POST /djs.json
  def create
    if params[:trainee_id].blank?
      @dj = Dj.new dj_params
      @dj.password = Time.zone.now.to_s
    else
      trainee = Trainee.find(params[:trainee_id])
      @dj = Dj.new trainee.attributes.slice(*(Dj.column_names - ['id']))
      @dj.password ||= trainee.created_at.to_s
    end

    respond_to do |format|
      if @dj.save
        trainee&.mark_graduated(approved_by: current_dj,
                                associated_dj_instance: @dj)
        @dj.add_role(:grandfathered_in) if params[:grandfathered] == '1'
        @dj.send_reset_password_instructions

        format.html { redirect_to @dj, notice: "#{@dj.name} is now a WCBN DJ." }
        format.json { render :show, status: :created, location: @dj }
      else
        format.html { render :new }
        format.json { render json: @dj.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /djs/1
  # PATCH/PUT /djs/1.json
  def update
    authorize_action_for @dj

    if @dj.update(dj_params)
      redirect_to @dj, successfully_updated
    else
      render :edit
    end
  end

  private

  def set_dj
    show_assoc = %i[freeform_shows specialty_shows talk_shows].map do |show|
      [show, :semester]
    end
    show_assoc << %i[episodes show]
    @dj = Dj.includes(Hash[show_assoc]).find(params[:id])
  end

  def dj_params
    params.require(:dj).permit(:name, :phone, :email, :umid, :um_affiliation,
                               :um_dept, :experience, :referral, :interests,
                               :statement, :real_name_is_public, :dj_name,
                               :website, :public_email, :about, :lists, :active,
                               :avatar, images: [])
  end
end
