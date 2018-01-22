require 'google/apis/calendar_v3'


class EventsController < ApplicationController
  def index
    # name, id, scope
    calendar = CalendarService.new('WCBN Events Info',
                                   'jjdakqoft456pv0rur6nrj27ro@group.calendar.google.com',
                                   Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY)
    
    events = calendar.fetch_upcoming(20)
    @days = events.chunk { |e| e.start.date_time.to_date } #TODO handle all-day events, which won't accept a call to .to_date
  end
end