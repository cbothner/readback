# Clone a selection of shows from one semester into another
class SemesterClonerJob < ApplicationJob
  queue_as :default

  # @param show_types_to_copy [Hash<class_name: String, ids: Array<Number>>]
  # @param into_semester [Semester]
  def perform(show_types_to_copy, into_semester:)
    show_types_to_copy.each do |type, ids|
      clone_shows_of_type type, ids: ids, into_semester: into_semester
    end
  end

  private

  def clone_shows_of_type(type, ids:, into_semester:)
    ids.each do |id|
      clone_show(find_show(type, id), into_semester: into_semester)
    end
  end

  def find_show(type, id)
    type.camelize.singularize.constantize.find(id)
  end

  def clone_show(show, into_semester:)
    new_show = show.class.new(attributes_to_clone(show))
    new_show.semester = into_semester
    new_show.set_times time_params show

    # Save the show without validating time conflicts because the model
    # semester ought to enforce that, and the check makes save slow.
    new_show.save(validate: false) # Callback propagates

    copy_djs(new_show, from: show) if new_show.is_a? SpecialtyShow
  end

  def attributes_to_clone(show)
    show.attributes.slice(
      'name', 'weekday', 'dj_id', 'coordinator_id', 'topic', 'description'
    )
  end

  def time_params(show)
    { weekday: show.times.first.wday, hour: show.times.first.hour,
      minute: show.times.first.min, duration: show.times.duration }
  end

  def copy_djs(new_show, from:)
    from.djs.each { |o| new_show.djs << o }
  end
end
