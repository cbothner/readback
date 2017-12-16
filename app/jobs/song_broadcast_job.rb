class SongBroadcastJob < ApplicationJob
  queue_as :default

  def perform(song)
    ActionCable.server.broadcast PlaylistChannel::NAME,
                                 type: PlaylistChannel::SONG_CREATED_TYPE,
                                 song: song
  end
end
