# frozen_string_literal: true

class UpcomingEpisodesController < ApplicationController
  before_action :authenticate_dj!

  decorates_assigned :dj, :episodes

  def index
    set_dj
    set_episodes
  end

  private

  def set_dj
    @dj = if params[:dj_id].present? && current_dj.has_role?(:superuser)
            Dj.find params[:dj_id]
          else
            current_dj
          end
  end

  def set_episodes
    @episodes = @dj.episodes.future
  end
end
