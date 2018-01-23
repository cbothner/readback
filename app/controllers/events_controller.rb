# frozen_string_literal: true

# @see Event
class EventsController < ApplicationController
  def index
    events = FetchEvents.from calendar_id
    @events = EventsDecorator.decorate events
  end

  private

  def calendar_id
    'umich.edu_ufhcesmo1sb25vqr2k6ftm9m64@group.calendar.google.com'
  end
end
