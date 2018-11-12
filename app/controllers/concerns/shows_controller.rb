# frozen_string_literal: true

module ShowsController
  extend ActiveSupport::Concern

  included do
    authorize_actions_for controller_name.singularize.camelize.constantize,
                          except: :show
    before_action :set_show, only: %i[show update destroy deal]
    before_action :define_params_method, only: %i[create update]
  end

  private

  def active_record_find_includes; end

  def set_show(includes: active_record_find_includes)
    model = controller_path.singularize.camelize.constantize

    @show = model.includes(includes).find params[:id]
  end

  def define_params_method
    self.class.send :define_method, "#{controller_path.singularize}_params" do
      hash = {}
      hash.merge! params.require(controller_path.singularize).permit(:name, :topic, :description, :website)
    end
  end
end
