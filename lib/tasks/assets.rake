# frozen_string_literal: true

namespace :assets do
  desc 'Run webpack with the server conf to make one non-codesplit bundle'
  task :build_server_side_bundle do
    system 'NODE_ENV=server bin/webpack'
  end
end

Rake::Task['assets:precompile'].enhance ['assets:build_server_side_bundle']
