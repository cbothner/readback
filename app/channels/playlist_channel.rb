class PlaylistChannel < ApplicationCable::Channel
  NAME = 'playlist_channel'.freeze
  SONG_CREATED_TYPE = 'song_created'.freeze
  SONG_UPDATED_TYPE = 'song_updated'.freeze
  SONG_DESTROYED_TYPE = 'song_destroyed'.freeze

  def subscribed
    transmit_now_playing_song
    stream_from NAME
  end

  def unsubscribed; end

  private

  def transmit_now_playing_song
    transmit type: SONG_CREATED_TYPE, song: Song.on_air
  end
end
