# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Playlist
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'

    config.autoload_paths += %W[#{config.root}/lib]

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: true,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.active_job.queue_adapter = :sidekiq
    config.action_dispatch.rack_cache = true

    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] =
      :forbidden
  end
end
