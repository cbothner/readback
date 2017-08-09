class DemoTapesController < ApplicationController
  def create
    @demo_tape = DemoTape.new trainee_editable_params
    @demo_tape.trainee = Trainee.find params[:trainee_id]

    authorize_action_for @demo_tape

    @demo_tape.save
    redirect_to @demo_tape.trainee
  end

  private

  def trainee_editable_params
    params.require(:demo_tape).permit(:url)
  end
end
