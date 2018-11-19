# frozen_string_literal: true

module SidebarHelper
  def on_air
    @on_air ||= Episode.on_air
  end

  def upcoming_episodes
    Episode.includes(:dj, show: [:dj]).future.limit(2)
  end
end
