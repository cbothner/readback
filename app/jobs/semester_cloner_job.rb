class SemesterClonerJob < ApplicationJob
  queue_as :default

  def perform(show_types_to_copy, into_semester:)
    show_types_to_copy.each do |type, ids|
      clone_shows show_type: type, ids: ids, into_semester: into_semester
    end
  end

  private
  def clone_shows(show_type:, ids:, into_semester:)
    ids.each do |id|
      old = show_type.camelize.singularize.constantize.find(id)

      new = old.class.new(
        old.attributes.slice *%w(name weekday dj_id coordinator_id topic description )
      )
      new.semester = into_semester

      times_params = { weekday: old.times.first.wday,
                       hour: old.times.first.hour, minute: old.times.first.min,
                       duration: old.times.duration }
      new.set_times times_params

      # Save the show without validating time conflicts because the model
      # semester ought to enforce that, and the check makes save slow.
      if new.save(validate: false)  # Callback propagates
        old.djs.each {|o| new.djs << o} if new.is_a? SpecialtyShow
      else
        raise "Clone Error"
      end
    end
  end
end
