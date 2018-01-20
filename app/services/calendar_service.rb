# frozen_string_literal: true

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/redis_token_store'
require 'redis'


class CalendarService
  CLIENT_SECRETS_PATH = 'client_secret.json'.freeze # super secret .gitignored file
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  
  def initialize(calendar_name, calendar_id, scope)
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.client_options.application_name = calendar_name
    @calendar.authorization = authorize(scope)
    @calendar_id= calendar_id
  end
  
  
  def fetch_upcoming(how_many)
    response = @calendar.list_events(@calendar_id,
                                   max_results: how_many,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: Time.now.iso8601)
    events = []

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start})"
      events.push(event)
    end

    events
  end
  
  
  
  private
  
  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # or intitiating an OAuth2 authorization.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize(scope)
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI
      )
      
      #TODO there's gotta be a better way to do this
      puts 'Open the following URL in the browser and enter the ' \
           'resulting code after authorization'
      puts url
      code = 'NAVIGATE TO `url` AND PASTE IN YOUR CODE'
      
      
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end