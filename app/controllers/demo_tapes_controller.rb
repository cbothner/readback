class DemoTapesController < ApplicationController
  before_action :set_demo_tape, only: %i[edit update]
  def create
    @demo_tape = DemoTape.new trainee_editable_params
    @demo_tape.trainee = Trainee.find params[:trainee_id]

    authorize_action_for @demo_tape

    @demo_tape.save
    redirect_to @demo_tape.trainee
  end

  def edit
    authorize_action_for @demo_tape
    render layout: 'thin'
  end

  def update
    authorize_action_for @demo_tape

    if @demo_tape.update(coordinator_editable_params)
      redirect_to @demo_tape.trainee,
                  notice: 'Feedback was successfully sent.'
    else
      render :edit
    end
  end

  private

  def set_demo_tape
    @demo_tape = DemoTape.find params[:id]
  end

  def trainee_editable_params
    params.require(:demo_tape).permit(:url)
  end

  def coordinator_editable_params
    params.require(:demo_tape).permit(:feedback, :accepted_at)
          .merge(accepted_at: params[:accepted] ? Time.zone.now : nil)
  end
end
