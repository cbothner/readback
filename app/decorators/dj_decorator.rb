# frozen_string_literal: true

# @see Dj
class DjDecorator < Draper::Decorator
  delegate_all

  def shows_by_name
    shows
      .sort_by(&:semester)
      .reverse
      .reject { |x| x.semester.future? }
      .group_by(&:unambiguous_name)
      .sort_by { |_, shows| shows.first.class.name }
      .sort_by { |_, shows| -shows.length }
  end

  def recent_episodes
    episodes
      .where('beginning < ?', Time.zone.now)
      .order(beginning: :desc)
      .limit(10)
      .decorate
  end
end
