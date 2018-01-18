# frozen_string_literal: true

class CalendarService
  def initialize(calendar_name)
    @calendar_name = calendar_name
    initialize_connection
  end
  
  def events
    return all the events
  end
  
  private
  
  def initialize_connection
    @connection = Google::Apis::CalendarV3::CalendarService.new
    @connection.client_options.application_name = APPLICATION_NAME
    @connection.authorization = authorize
  end
end