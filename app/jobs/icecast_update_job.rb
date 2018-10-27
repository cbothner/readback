# frozen_string_literal: true

# Set the given song’s information as the metadata of the icecast stream.
class IcecastUpdateJob < ApplicationJob
  queue_as :default

  # @param [Song]
  def perform(song = nil)
    return unless ENV['ICECAST_ADMIN_PASSWORD']

    %w[hd mid hi].each do |qual|
      system(
        'curl',
        '--max-time', '0.5',
        '--user', "admin:#{ENV['ICECAST_ADMIN_PASSWORD']}",
        icecast_endpoint(qual, song)
      )
    end
  end

  private

  def icecast_endpoint(qual, song)
    mount = "/wcbn-#{qual}.mp3"
    'http://floyd.wcbn.org:8000/admin/metadata' \
      "?mount=#{mount}&song=#{Rack::Utils.escape metadata_string song}" \
      '&mode=updinfo'
  end

  def metadata_string(song)
    return episode_string Episode.on_air if song.blank?

    artist = " by #{song.artist}" unless song.artist.blank?
    "WCBN-FM: “#{song.name}”#{artist} – " \
      "on #{episode_string song.episode}"
  end

  def episode_string(episode)
    "#{episode.show.name} with #{episode.dj}"
  end
end
