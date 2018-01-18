class EventsController < ApplicationController
  def index
    @events = CalendarService.new(:events).events
  end
end