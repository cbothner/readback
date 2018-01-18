require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'


class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show]
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'WCBN Events and Concerts Info'.freeze
  CLIENT_SECRETS_PATH = 'client_secret.json'.freeze
  CREDENTIALS_PATH = File.join(Dir.getwd, '.credentials', 'calendar-ruby-quickstart.yaml')
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def index
    # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # Fetch the next 10 events
    calendar_id = 'umich.edu_e5nqekg2rvo7nsa7t64neu802c@group.calendar.google.com'
    response = service.list_events(calendar_id,
                                   max_results: 20,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: Time.now.iso8601)

    events = []

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start})"
      events.push(event)
      # puts event.start.date_time.to_date
    end

    @days = events.chunk { |e| e.start.date_time.to_date }
  end

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI
      )
      puts 'Open the following URL in the browser and enter the ' \
           'resulting code after authorization'
      puts url
      code = '4/GCQqH4nhqV8sgdbIcTc5XiVMANRcyiiJtK8sz-pUIWU'
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar_params
    params.fetch(:calendar, {})
  end
end
