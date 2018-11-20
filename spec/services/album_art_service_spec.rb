# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumArtService, type: :model do
  describe '::fetch' do
    it 'returns the album artwork url for the first match on iTunes' do
      query = 'The Decemberists Sons and Daughters'

      stub_request(:get, 'https://itunes.apple.com/search')
        .with(
          query: { 'entity' => 'musicTrack', 'limit' => '1', 'term' => query }
        ).to_return body: {
          results: [
            {
              artworkUrl100: 'artworkUrl'
            }
          ]
        }.to_json

      artwork_url = AlbumArtService.fetch query
      expect(artwork_url).to eq 'artworkUrl'
    end
  end
end
