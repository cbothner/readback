# frozen_string_literal: true

# @see Episode
class EpisodeDecorator < Draper::Decorator
  EN_SPACE = "\u2002"

  delegate_all

  def date_string
    h.localize beginning.to_date, format: :long
  end

  def time_string
    return until_ending if range.include? Time.zone.now
    return range_string if beginning.today?
    absolute_time_string
  end

  def activity
    ActivityFormatter.for(model)
  end

  private

  def range_string
    "#{format_time beginning} – #{format_time ending}"
  end

  def format_time(time)
    I18n.l time, format: '%l:%M %p'
  end

  def until_ending
    "Until #{format_time ending}"
  end

  def absolute_time_string
    "#{I18n.l beginning.to_date, format: :long}#{EN_SPACE}#{range_string}"
  end
end
