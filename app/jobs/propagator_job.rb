class PropagatorJob < ApplicationJob
  queue_as :default

  def perform(instance, from = Time.zone.now.to_i, til = Semester.maximum(:ending).to_i)
    instance.propagate(Time.at(from), Time.at(til))
  end
end
