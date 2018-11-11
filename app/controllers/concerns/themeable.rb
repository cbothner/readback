# frozen_string_literal: true

module Themeable
  class ThemeNotFoundError < StandardError; end

  extend ActiveSupport::Concern

  included do
    before_action -> { with_theme }

    helper_method :theme
  end

  class_methods do
    attr_reader :default_theme_name

    def with_theme(theme_name)
      before_action -> { with_theme theme_name }
    end
  end

  private

  attr_reader :theme_name

  def with_theme(theme_name = self.class.default_theme_name)
    @theme_name = theme_name
  end

  def theme
    return Theme.send theme_name if Theme.respond_to? theme_name

    logger.error "ThemeNotFoundError: Theme.#{theme_name} is not defined"
    Theme.sky_blue
  end
end
