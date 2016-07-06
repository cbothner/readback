class EpisodeMailer < ApplicationMailer
  def reminder(episode)
    @episode = episode
    next_week = @episode.beginning + 1.week
    @next = @episode.show.episodes.select { |ep| ep.beginning == next_week }.try :first

    mail to: @episode.show.hosts.map(&:name_and_email),
      subject: "#{@episode.active_dj} is on #{@episode.show.name} this week"
  end
end
