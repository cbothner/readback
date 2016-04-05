module ShowsController
  extend ActiveSupport::Concern

  included do 

    authorize_actions_for controller_name.singularize.camelize.constantize, except: :show
    before_action :set_instance_variable, only: [:show, :update, :destroy, :deal]
    before_action :define_params_method, only: [:create, :update]
    layout "headline"

  end

  private

  def active_record_find_includes
  end

  def set_instance_variable(includes: active_record_find_includes)
    model = controller_path.singularize.camelize.constantize
    inst_var_name = "@#{controller_path.singularize}"

    show = model.includes(includes).find(params[:id])
    @episodes = show.episodes.sort_by &:beginning

    unless instance_variable_defined? inst_var_name
      instance_variable_set inst_var_name, show
    end
  end

  def define_params_method 
    self.class.send :define_method, "#{controller_path.singularize}_params" do
      hash = {}
      hash.merge! params.require(controller_path.singularize).permit(:name, :topic, :description)
    end
  end
end
