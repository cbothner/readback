class SemestersController < ApplicationController
  before_filter :authenticate_dj!, except: [:index, :show]
  authorize_actions_for Semester, except: [:index, :show]

  before_action :set_semester, only: [:show, :edit, :update, :destroy]
  before_action :set_model, only: [:new, :create]

  layout "headline"

  # GET /semesters
  # GET /semesters.json
  def index
    redirect_to Semester.current
  end

  # GET /semesters/1
  # GET /semesters/1.json
  def show
    @semesters = Semester.all.sort_by(&:beginning).reverse
    render layout: 'wide_with_sidebar'
    expires_in 10.minutes, public: true
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
    @semester.beginning = Semester.current.ending.strftime "%%Y-%B-%d"
  end

  # GET /semesters/1/edit
  def edit
    @semesters = Semester.all.sort_by(&:beginning).reverse
    [ FreeformShow, SpecialtyShow, TalkShow ].each do |x|
      instance_variable_set "@#{x.name.underscore}", @semester.method(x.name.underscore.pluralize).call.build
    end
  end

  # POST /semesters
  # POST /semesters.json
  def create
    show_types_to_copy = JSON.parse params.delete(:shows_to_copy)

    params[:semester][:beginning] = Time.zone.parse(params[:semester][:beginning])
      .change(hour: 6).beginning_of_hour
    params[:semester][:ending] = Time.zone.parse(params[:semester][:ending])
      .change(hour: 5, minute: 59, second:59)
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        show_types_to_copy.each { |type, ids| @semester.clone_shows show_type: type, ids: ids }
        Signoff.propagate_all(@semester.beginning, @semester.ending)

        format.html { redirect_to edit_semester_path @semester }
        format.json { render :show, status: :created, location: @semester }
      else
        format.html { render :new }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semesters/1
  # PATCH/PUT /semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semesters/1
  # DELETE /semesters/1.json
  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to semesters_url, notice: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semester(variable_name = 'semester')
      id = params[:id] || params.delete(:model_id)
      var = Semester
        .includes(freeform_shows: [:dj, :episodes],
                  specialty_shows: [:dj, :djs],
                  talk_shows: [:episodes])
        .find(id)
      shows = var.freeform_shows + var.specialty_shows + var.talk_shows
      shows.reject! {|x| x.beginning.nil? }
      @start_times = shows.map{|x| x.sort_times :beginning}.sort_by{|x| x[:sortable]}.uniq
      @shows = shows.group_by{|x| x.sort_times(:beginning)[:sortable]}
      self.instance_variable_set "@#{variable_name}", var
    end

    def set_model
      set_semester('model')
    end

    def semester_params
      hash = {}
      hash.merge! params.require(:semester).permit(:beginning, :ending)
      hash.merge! params.slice(:model_id, :shows_to_copy)
    end
end
# Never trust parameters from the scary internet, only allow the white list through.
