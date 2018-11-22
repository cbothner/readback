# frozen_string_literal: true

# @see Song
class SongDecorator < Draper::Decorator
  delegate_all

  # @return [string] “9:25 AM”
  def time_string
    at.strftime '%l:%M %p'
  end

  def artwork_path
    h.song_album_artwork_path object
  end
end
