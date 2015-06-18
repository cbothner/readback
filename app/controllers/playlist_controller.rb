class PlaylistController < ApplicationController
  def index
    songs = Song.where(at: 6.hours.ago..Time.zone.now)
    shows = Episode.where(beginning: 6.hours.ago..4.hours.since)
    @on_air = Episode.on_air
    signoff_instances = SignoffInstance.where(at: 6.hours.ago..4.hours.since)

    items = (songs + shows - [@on_air] + signoff_instances).sort_by(&:at).reverse
    @past_items = items.select{|i| i.at <= Time.zone.now }
    @future_items = items - @past_items

    @song = Song.new(session[:song])  # TODO: clear this
    @song ||= Song.new
  end
end
