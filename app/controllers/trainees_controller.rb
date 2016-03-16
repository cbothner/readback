class TraineesController < ApplicationController
  before_filter :authenticate_dj!, except: :show
  authorize_actions_for Trainee, except: [:new, :create]
  before_action :set_trainee, only: [:show, :edit, :update, :destroy]

  layout "headline"

  # GET /trainees
  # GET /trainees.json
  def index
    @trainees = Trainee.includes(:episodes).where(disqualified: false)
      .reject { |t| t.broadcasters_exam.accepted? }
      .sort_by { |t| sortable(t) }
      .reverse

    respond_to do |format|
      format.html
      format.csv do 
        headers['Content-Disposition'] = "attachment; filename=\"wcbn-trainees-#{Time.zone.now.strftime "%F"}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  # GET /trainees/1
  # GET /trainees/1.json
  def show
    episodes = @trainee.episodes
    @apprenticeships = Hash.new
    sched = episodes.reject(&:past?)
    happened = (episodes - sched)
      .reject {|e| e.shadowed == false}
      .sort_by(&:beginning)
    @apprenticeships[:stage_two_training] = happened.empty? ? [] : [happened.shift]
    @apprenticeships[:freeform_apprenticeships] = happened
      .select{ |ep| ep.show.is_a? FreeformShow }
    @apprenticeships[:specialty_apprenticeships] = happened.select{ |ep| ep.show.is_a? SpecialtyShow }
    @apprenticeships[:scheduled_apprenticeships] = sched  # this is last for order in the view
  end

  # GET /trainees/new
  def new
    @trainee = Trainee.new
  end

  # GET /trainees/1/edit
  def edit
  end

  # POST /trainees
  # POST /trainees.json
  def create
    @trainee = Trainee.new(trainee_params)

    respond_to do |format|
      if @trainee.save
        format.html { redirect_to action: 'new', notice: 'Got it! Welcome to WCBN' }
        format.json { render :show, status: :created, location: @trainee }
      else
        format.html { render :new }
        format.json { render json: @trainee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trainees/1
  # PATCH/PUT /trainees/1.json
  def update
    if params[:trainee].include? :demotape
      @trainee.demotape = Trainee::Acceptance.new(Time.zone.now, current_dj.id,
                                                  params[:trainee][:demotape])
    end

    respond_to do |format|
      if @trainee.update(trainee_params)
        format.html { redirect_to @trainee, notice: 'Trainee was successfully updated.' }
        format.json { render :show, status: :ok, location: @trainee }
      else
        format.html { render :edit }
        format.json { render json: @trainee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trainees/1
  # DELETE /trainees/1.json
  def destroy
    @trainee.destroy
    respond_to do |format|
      format.html { redirect_to trainees_url, notice: 'Trainee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trainee
      @trainee = Trainee.includes(episodes: [:show]).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trainee_params
      params.require(:trainee).permit(:name, :phone, :email, :umid,
                                     :um_affiliation, :um_dept, :experience,
                                     :referral, :interests, :statement,
                                     :disqualified)
    end

    def sortable(t)
      if params[:sort] == "progress"
        # t.volunteer_hours +
        (t.demotape.accepted? ? 10 : 0) +
          (100 * t.episodes.count)
      else
        t.created_at
      end
    end
end
