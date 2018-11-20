# frozen_string_literal: true

class AlbumArtService
  include HTTParty
  debug_output $stdout

  ARTWORK_KEY_PATH = ['results', 0, 'artworkUrl100'].freeze

  base_uri 'https://itunes.apple.com'

  attr_reader :query

  def self.fetch(query)
    new(query).fetch
  end

  def initialize(query)
    @query = query
  end

  def fetch
    if search_results.success?
      search_results.dig(*ARTWORK_KEY_PATH)
    else
      puts search_results
    end
  end

  private

  def search_results
    @search_results ||=
      self.class.get '/search', query: search_params, format: :json
  end

  def search_params
    { entity: 'musicTrack', limit: '1', term: query }
  end
end
