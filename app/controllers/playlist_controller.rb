class PlaylistController < ApplicationController
  def index
    songs = Song.where(at: (Time.now - 6.hours)..Time.now)
    shows = ShowInstance.where(beginning: (Time.now - 6.hours)..(Time.now + 3.hours))
    @on_air = ShowInstance.on_air
    items = (songs + shows - [@on_air]).sort_by(&:at).reverse
    @past_items = items.select{|i| i.at <= Time.now }
    @future_items = items - @past_items

    @song = Song.new(session[:song])
    @song ||= Song.new
  end
end
