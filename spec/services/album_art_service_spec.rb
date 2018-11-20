# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumArtService, type: :model do
  describe '::fetch' do
    it 'searches the Spotify API for the album and returns the artwork url' do
      stub_spotify_authentication_requests

      query = { artist: 'The Decemberists', album: 'The Crane Wife',
                track: 'Sons and Daughters' }

      stub_request(:get, 'https://api.spotify.com/v1/search')
        .with(
          query: {
            q: 'The Decemberists The Crane Wife',
            type: 'album', limit: '1', offset: '0'
          }
        ).to_return body: {
          albums: {
            items: [{ images: [{ url: 'artworkUrl' }] }]
          }
        }.to_json

      artwork_url = AlbumArtService.fetch query
      expect(artwork_url).to eq 'artworkUrl'
    end

    context 'when given only an artist and a track' do
      it 'does a track search and returns the artwork of the track’s album' do
        stub_spotify_authentication_requests

        query = { artist: 'The Decemberists', track: 'Sons and Daughters',
                  album: '' }

        stub_request(:get, 'https://api.spotify.com/v1/search')
          .with(
            query: {
              q: 'The Decemberists Sons and Daughters',
              type: 'track', limit: '1', offset: '0'
            }
          ).to_return body: {
            tracks: {
              items: [{ album: { images: [{ url: 'artworkUrl' }] } }]
            }
          }.to_json

        artwork_url = AlbumArtService.fetch query
        expect(artwork_url).to eq 'artworkUrl'
      end
    end
  end
end

def stub_spotify_authentication_requests
  stub_request(:post, 'https://accounts.spotify.com/api/token')
    .with(body: { grant_type: 'client_credentials' })
    .to_return body: {
      access_token: 'token',
      token_type: 'bearer',
      expires_in: 3600
    }.to_json
end
