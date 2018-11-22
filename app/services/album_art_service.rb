# frozen_string_literal: true

class AlbumArtService
  attr_reader :query

  def self.fetch(query)
    new(query).fetch
  end

  def initialize(query)
    @query = query.symbolize_keys
    authenticate
  end

  def fetch
    return if album.nil? || album.images.empty?

    album.images.dig(0, 'url')
  end

  private

  def authenticate
    credentials = Rails.application.credentials.spotify
    RSpotify.authenticate credentials[:client_id], credentials[:client_secret]
  end

  def album
    @album ||= if query[:album].present?
                 album_search_results.first
               else
                 track_search_results.first.album
               end
  end

  def album_search_results
    q = query_string_from %i[artist album]
    RSpotify::Album.search q, limit: 1
  end

  def track_search_results
    q = query_string_from %i[artist track]
    RSpotify::Track.search q, limit: 1
  end

  def query_string_from(keywords)
    keywords.map { |k| query[k] }.join ' '
  end
end
