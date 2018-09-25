# frozen_string_literal: true

namespace :episode_information do
  desc 'Push the current episode’s information to RDS and Icecast'
  task push: :environment do
    if Episode.on_air.songs.none?
      RdsUpdateJob.perform_now
      IcecastUpdateJob.perform_now
    end
  end
end
