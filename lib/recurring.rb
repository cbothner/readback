module Recurring
  extend ActiveSupport::Concern

  included do
    serialize :times, IceCube::Schedule
  end

  def propagate(from = Time.zone.now, til = Semester.maximum(:ending))
    instances = self.method(instance_collection_name).call
    enumerator(from, til).each do |t|
      break if t > til
      next if includes_instance_at?(t)
      instances.create instance_params(t)
    end
  end

  private
  def enumerator(from = Time.zone.now, til = Semester.maximum(:ending))
    times.remaining_occurrences_enumerator(from)
  end

  def instance_collection_name
    "#{self.class.name.downcase.singularize}_instances"
  end

end
