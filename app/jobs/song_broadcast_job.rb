class SongBroadcastJob < ApplicationJob
  queue_as :default

  def perform(song)
    ActionCable.server.broadcast PlaylistChannel::NAME,
                                 type: type(song),
                                 song: song
  end
  
  rescue_from ActiveJob::DeserializationError do |exception|
    ActionCable.server.broadcast PlaylistChannel::NAME,
                                 type: PlaylistChannel::SONG_DESTROYED_TYPE,
                                 id: exception.cause.id
  end

  private

  def type(song)
    if song.created_at == song.updated_at
      PlaylistChannel::SONG_CREATED_TYPE
    else
      PlaylistChannel::SONG_UPDATED_TYPE
    end
  end
end
