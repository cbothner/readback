class PlaylistController < ApplicationController
  def index
    songs = Song.all.sort_by(&:at).reverse
    @items = songs

    @song = Song.new
  end
end
