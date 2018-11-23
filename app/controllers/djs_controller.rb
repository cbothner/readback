# frozen_string_literal: true

class DjsController < ApplicationController
  before_action :authenticate_dj!, except: :show
  before_action :set_djs, only: %i[index create]
  before_action :set_dj, only: %i[show edit update destroy]

  decorates_assigned :dj

  # GET /djs
  # GET /djs.json
  def index
    @dj = Dj.new

    respond_to do |format|
      format.html { authorize Dj }
      format.pdf { @djs = @djs.active }
      format.csv do
        @djs = @djs.active
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

  # POST /djs
  # POST /djs.json
  def create
    authorize Dj

    # if params[:trainee_id].blank?
    @dj = Dj.new dj_params
    @dj.password = SecureRandom.base64
    # else
    # trainee = Trainee.find(params[:trainee_id])
    # @dj = Dj.new trainee.attributes.slice(*(Dj.column_names - ['id']))
    # @dj.password ||= trainee.created_at.to_s
    # end

    if @dj.save
      # trainee&.mark_graduated(approved_by: current_dj,
      # associated_dj_instance: @dj)
      redirect_to @dj, flash: { success: "#{@dj.name} is now a WCBN DJ." }
    else
      render :index
    end
  end

  # GET /djs/1/edit
  def edit
    authorize @dj
  end

  # PATCH/PUT /djs/1
  # PATCH/PUT /djs/1.json
  def update
    authorize @dj

    if update_dj
      bypass_sign_in @dj, scope: :dj
      redirect_to @dj, successfully_updated
    else
      render :edit
    end
  end

  private

  def set_djs
    @djs = policy_scope Dj
  end

  def set_dj
    show_assoc = %i[freeform_shows specialty_shows talk_shows].map do |show|
      [show, :semester]
    end
    show_assoc << %i[episodes show]
    @dj = Dj.includes(Hash[show_assoc]).find(params[:id])
  end

  def dj_params
    params.require(:dj).permit(
      :name, :phone, :email, :umid, :um_affiliation, :um_dept, :experience,
      :referral, :interests, :statement, :real_name_is_public, :dj_name,
      :website, :public_email, :about, :lists, :active, :avatar, :password,
      :password_confirmation, :current_password,
      images: []
    )
  end

  def update_dj
    if dj_params['password'].present?
      @dj.update_with_password dj_params
    else
      profile_params = dj_params
      profile_params.delete 'current_password'
      @dj.update_without_password profile_params
    end
  end
end
