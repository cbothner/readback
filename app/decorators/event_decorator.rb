# frozen_string_literal: true

# @see Event
class EventDecorator < Draper::Decorator
  delegate_all

  def beginning
    Moment.for super
  end
end

class EventDecorator
  # Let’s abstract the differences between a TimeWithZone and a Date. This is
  # the factory pattern: we create an object whose specific type we don’t need
  # to know at the call site---as long as it implements a common interface.
  # This encapsulates the decision about how it should actually behave.
  class Moment
    Time = Struct.new(:moment) do
      delegate_missing_to :moment

      def formatted_time
        I18n.l moment, format: '%l:%M %p'
      end
    end

    Date = Class.new(Time) do
      def formatted_time
        'All day'
      end
    end

    def self.for(moment)
      moment.acts_like?(:date) ? Date.new(moment) : Time.new(moment)
    end
  end
end
