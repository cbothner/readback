# frozen_string_literal: true

# Set the station’s RDS broadcast to the given song’s information
class RdsUpdateJob < ApplicationJob
  queue_as :default

  # @param [Song]
  def perform(song = nil)
    unless rds_tunnel_options
      logger.warn 'Skipping RDS update because tunnel credentials are missing'
      return
    end

    logger.debug("Updating RDS: `#{I18n.transliterate(metadata_string(song))}`")

    Net::SSH.start(*rds_tunnel_options) do |ssh|
      command = format rds_settings song
      result = ssh.exec! "echo -n \"#{command}\" | nc 10.211.81.205 22201"
      puts result.gsub "\n\r", ', '
    end
  end

  rescue_from StandardError do |exception|
    # Log exception but don't allow the job to be retried
    Raven.capture_exception exception
  end

  private

  def rds_tunnel_options
    host = ENV['RDS_TUNNEL_HOST']
    user = ENV['RDS_TUNNEL_USER']
    key = ENV['RDS_TUNNEL_KEY']

    return unless host && user && key

    [host, user, key_data: [key]]
  end

  def format(settings)
    settings.map { |k, v| "#{k}=#{v}" }.join("\r\n") + "\r\n"
  end

  def rds_settings(song)
    {
      PS: 'WCBN-FM',
      PI: '5A17',
      PTY: '23',
      PTYN: 'College',
      RT: I18n.transliterate(metadata_string(song))
    }
  end

  def metadata_string(song)
    return episode_string Episode.on_air if song.blank?

    "#{song.artist}--#{song.name}--#{episode_string song.episode}"
  end

  def episode_string(episode)
    "#{episode.show.name} w/ #{episode.dj}"
  end
end
