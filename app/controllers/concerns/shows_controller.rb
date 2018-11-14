# frozen_string_literal: true

module ShowsController
  extend ActiveSupport::Concern

  included do
    authorize_actions_for controller_name.singularize.camelize.constantize,
                          except: :show
    before_action :set_show, only: %i[show update destroy deal]
  end

  private

  def active_record_find_includes; end

  def set_show(includes: active_record_find_includes)
    model = controller_path.singularize.camelize.constantize

    @show = model.includes(includes).find params[:id]
  end

  def set_show_dj_from_params
    dj_id = show_params[:dj_id]
    return unless dj_id.present?

    @show.dj = Dj.find(dj_id)
  end

  def set_show_times_from_params
    @show.set_times_conditionally_from_params show_params
  end

  def show_params
    params.require(controller_path.singularize.to_sym)
  end
end
