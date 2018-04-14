# frozen_string_literal: true

module Themeable
  class ThemeNotFoundError < StandardError; end

  extend ActiveSupport::Concern

  included do
    before_action :set_theme
  end

  class_methods do
    def with_theme(theme_name)
      throw ThemeNotFoundError unless Theme.respond_to? theme_name

      define_method :theme do
        Theme.send theme_name
      end
    end
  end

  private

  def set_theme
    @theme = theme
  end
end
