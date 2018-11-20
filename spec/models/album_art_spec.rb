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
        .with(artist: 'The Decemberists', track: 'Sons and Daughters',
              album: 'The Crane Wife')
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

    it 'doesn’t search twice for two different songs from the same album' do
      use_cache

      service = class_double 'AlbumArtService'
      allow(service).to receive(:fetch)

      song1 = build_stubbed :song, sons_and_daughters
      song2 = build_stubbed :song, after_the_bombs

      [song1, song2].each do |song|
        AlbumArt.for_song song, artwork_service: service
      end

      expect(service).to have_received(:fetch).once
    end

    it 'doesn’t consider two songs with blank album to be on the same album' do
      use_cache

      service = class_double 'AlbumArtService'
      allow(service).to receive(:fetch)

      song1 = build_stubbed :song, sons_and_daughters.merge(album: '')
      song2 = build_stubbed :song, after_the_bombs.merge(album: '')

      [song1, song2].each do |song|
        AlbumArt.for_song song, artwork_service: service
      end

      expect(service).to have_received(:fetch).exactly(2).times
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

def after_the_bombs
  {
    artist: 'The Decemberists',
    name: 'After the Bombs',
    album: 'The Crane Wife'
  }
end
