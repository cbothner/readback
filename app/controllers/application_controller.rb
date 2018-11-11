# frozen_string_literal: true

require 'csv'

class ApplicationController < ActionController::Base
  include Themeable
  include TranslatedFlashMessages

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_sidebar_variables

  layout 'redesign'

  with_theme :sky_blue

  private

  def current_user
    current_dj || current_playlist_editor
  end

  def set_sidebar_variables
    @upcoming_episodes =
      Episode.includes(:dj, show: [:dj]).future.limit(3)
  end
end
