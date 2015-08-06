class DjsController < ApplicationController
  before_filter :authenticate_dj!, except: :show
  authorize_actions_for Dj, except: [:show, :edit, :update]

  before_action :set_dj, only: [:show, :edit, :update, :destroy]

  # GET /djs
  # GET /djs.json
  def index
    djs = Dj.all
    @trainees = djs.reject(&:active).sort_by(&:created_at).reverse
    non_trainees = (djs - @trainees).sort_by(&:name)
    @active_djs = non_trainees.select{ |dj| dj.semesters_count > 0 }
    @trained = (non_trainees - @active_djs)

    respond_to do |format|
      format.html
      format.pdf {
        @djs = (@active_djs + @trained).sort_by(&:name)
      }
    end
  end

  # GET /djs/1
  # GET /djs/1.json
  def show
    @shows = @dj.shows.group_by(&:unambiguous_name)
    @recent_episodes = @dj.episodes.where("beginning < ?", Time.zone.now)
      .order(beginning: :desc).first(5)
  end

  # GET /djs/new
  def new
    @dj = Dj.new
    render layout: "headline"
  end

  # GET /djs/1/edit
  def edit
    authorize_action_for @dj
  end

  # POST /djs
  # POST /djs.json
  def create
    trainee = Trainee.find(params[:trainee_id])
    @dj = Dj.new trainee.attributes.slice(*(Dj.column_names - ['id']))
    @dj.password ||= "#{trainee.created_at}"

    respond_to do |format|
      if @dj.save
        trainee.broadcasters_exam = Trainee::Acceptance.new(Time.zone.now,
                                                            current_dj.id, "")
        trainee.save
        flash[:notice] = 'Got it! Welcome to WCBN'
        format.html { redirect_to @dj, notice: "#{@dj.name} is now a WCBN DJ." }
        format.json { render :show, status: :created, location: @dj }
      else
        format.html { render :edit }
        format.json { render json: @dj.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /djs/1
  # PATCH/PUT /djs/1.json
  def update
    authorize_action_for @dj
    respond_to do |format|
      if @dj.update(dj_params)
        format.html { redirect_to @dj, notice: 'Dj was successfully updated.' }
        format.json { render :show, status: :ok, location: @dj }
      else
        format.html { render :edit }
        format.json { render json: @dj.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /djs/1
  # DELETE /djs/1.json
  def destroy
    @dj.destroy
    respond_to do |format|
      format.html { redirect_to djs_url, notice: 'Dj was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dj
      show_assoc = [:freeform_shows, :specialty_shows, :talk_shows].map do |show|
        [show, :semester]
      end
      show_assoc << [:episodes, :show]
      @dj = Dj.includes(Hash[show_assoc]).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dj_params
      params.require(:dj).permit(:name, :phone, :email, :umid, :um_affiliation,
                                 :um_dept, :experience, :referral, :interests,
                                 :statement, :real_name_is_public, :dj_name,
                                 :website, :public_email, :about, :lists)
    end
end
