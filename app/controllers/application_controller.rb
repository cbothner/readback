# frozen_string_literal: true

require 'csv'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

  private

  def current_user
    current_dj || current_playlist_editor
  end

  def set_raven_context
    Raven.user_context(
      email: current_dj.email, playlist_editor: playlist_editor_signed_in?
    )
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
