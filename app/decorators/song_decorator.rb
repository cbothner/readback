# @see Song
class SongDecorator < Draper::Decorator
  delegate_all

  # @return [string] “9:25 AM”
  def time_string
    at.strftime '%l:%M %p'
  end
end
