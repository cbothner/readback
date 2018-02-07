# frozen_string_literal: true

# Set the given song’s information as the metadata of the icecast stream.
class IcecastUpdateJob < ApplicationJob
  queue_as :default

  # @param [Song]
  def perform(song)
    return unless ENV['ICECAST_ADMIN_PASSWORD']

    %w[hd mid hi].each do |qual|
      Kernel.system(
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
    artist = " by #{song.artist}" unless artist.blank?
    "WCBN-FM: “#{song.name}”#{artist} – " \
      "on #{song.episode.show.name} with #{song.episode.dj}"
  end
end
