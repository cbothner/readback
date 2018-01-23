# frozen_string_literal: true

# @see Event
class EventsDecorator < Draper::CollectionDecorator
  def days
    object.chunk { |event| event.beginning.to_date }
  end
end
