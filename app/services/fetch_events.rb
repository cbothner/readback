# frozen_string_literal: true

# Gets the events from Google Calendar for display on the events/concerts pages
class FetchEvents
  # @param calendar_id [String] must be a public calendar, or one personally
  #   owned by the person whose API key is used.
  def self.from(calendar_id)
    new(calendar_id).call
  end

  def initialize(calendar_id)
    @calendar_id = calendar_id
  end

  def call
    cache do
      query_calendar_api
      parse_events
    end
  end

  private

  def cache
    Rails.cache.fetch("events/#{@calendar_id}", expires_in: 5.minutes) do
      yield
    end
  end

  def query_calendar_api
    @response = JSON.parse Net::HTTP.get endpoint
  end

  def endpoint
    uri = URI(
      "https://www.googleapis.com/calendar/v3/calendars/#{@calendar_id}/events"
    )
    uri.query = query_params
    uri
  end

  def query_params
    URI.encode_www_form(
      key: ENV['GOOGLE_CALENDAR_API_KEY'],
      orderBy: 'startTime',
      singleEvents: true,
      timeMin: Time.zone.now.iso8601,
      timeMax: 6.months.since.iso8601
    )
  end

  def parse_events
    @response['items'].map { |item| Event.new item }
  end
end
