class PlaylistController < ApplicationController
  def index
    songs = Song.includes(:episode).where(at: 6.hours.ago..Time.zone.now)
    shows = Episode.includes(:dj, show: [:dj]).where("beginning < '#{4.hours.since.utc}' and ending > '#{6.hours.ago.utc}'")
    @on_air = Episode.on_air
    signoff_instances = SignoffInstance.where(at: 6.hours.ago..4.hours.since)

    items = (songs + shows - [@on_air] + signoff_instances).sort_by(&:at).reverse
    @past_items = items.select{|i| i.at <= Time.zone.now }
    @future_items = items - @past_items

    session[:confirm_episode] = false unless session[:song]
    @song = Song.new(session.delete(:song))  # TODO: clear this
    @song ||= Song.new
    @song.episode ||= @on_air
  end
end
