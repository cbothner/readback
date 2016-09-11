class PropagatorJob < ApplicationJob
  queue_as :default

  def perform(instance, from = Time.zone.now.to_i, til = Semester.maximum(:ending).to_i)
    Rails.logger.info "Propagating #{instance.to_params}"
    instance.propagate(Time.at(from), Time.at(til))
  end
end
