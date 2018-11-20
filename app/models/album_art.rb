# frozen_string_literal: true

class AlbumArt
  attr_reader :song, :service

  def self.for_song(song, artwork_service: AlbumArtService)
    new(song, artwork_service).artwork
  end

  def initialize(song, artwork_service)
    @song = song
    @service = artwork_service
  end

  def artwork
    Rails.cache.fetch cache_key do
      service.fetch query
    end
  end

  private

  def cache_key
    if song.album.present?
      "#{song.artist}/#{song.album}/album_art"
    else
      "#{song.artist}/#{song.name}/album_art"
    end
  end

  def query
    {
      artist: song.artist,
      track: song.name,
      album: song.album
    }
  end
end
