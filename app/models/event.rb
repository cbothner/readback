# frozen_string_literal: true

# One event from Google Calendar API
class Event
  include Draper::Decoratable

  # @param item [calendar#event]
  def initialize(item)
    @data = item
  end

  def title
    @data['summary']
  end

  def description
    @data['description']
  end

  def location
    @data['location']
  end

  def beginning
    date_or_date_time @data['start']
  end

  def ending
    return nil if @data['endTimeUnspecified']
    date_or_date_time @data['end']
  end

  private

  def date_or_date_time(obj)
    return Time.zone.parse obj['dateTime'] if obj.key? 'dateTime'
    Date.parse obj['date'] if obj.key? 'date'
  end
end
