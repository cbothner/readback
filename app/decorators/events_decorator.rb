# frozen_string_literal: true

# @see Event
class EventsDecorator < Draper::CollectionDecorator
  def days
    decorated_collection.chunk { |event| event.beginning.to_date }
  end
end
