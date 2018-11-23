# frozen_string_literal: true

require 'csv'

class ApplicationController < ActionController::Base
  include Themeable
  include TranslatedFlashMessages
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'redesign'

  with_theme :sky_blue

  private

  def current_user
    current_dj || current_playlist_editor
  end
end
