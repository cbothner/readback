# frozen_string_literal: true

class AlbumArtworksController < ApplicationController
  def show
    if artwork_url.present?
      redirect_to artwork_url
    else
      head :not_found
    end
  end

  private

  def artwork_url
    @artwork_url ||= AlbumArt.for_song song
  rescue SocketError, HTTParty::Error
    nil
  end

  def song
    @song ||= Song.find params[:song_id]
  end
end
