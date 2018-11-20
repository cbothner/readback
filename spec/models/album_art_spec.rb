# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumArt do
  include UseCache

  describe '::for_song' do
    it 'uses an album art service to find an image' do
      service = class_double 'AlbumArtService'
      allow(service).to receive(:fetch).and_return 'artwork'

      song = build_stubbed :song, sons_and_daughters
      artwork_url = AlbumArt.for_song song, artwork_service: service

      expect(artwork_url).to eq 'artwork'
      expect(service).to have_received(:fetch)
        .with('The Decemberists Sons and Daughters The Crane Wife')
    end

    it 'caches the result so it doesn’t search twice for the same song' do
      use_cache

      service = class_double 'AlbumArtService'
      allow(service).to receive(:fetch)

      song = build_stubbed :song, sons_and_daughters
      2.times do
        AlbumArt.for_song song, artwork_service: service
      end

      expect(service).to have_received(:fetch).once
    end
  end
end

def sons_and_daughters
  {
    artist: 'The Decemberists',
    name: 'Sons and Daughters',
    album: 'The Crane Wife'
  }
end
