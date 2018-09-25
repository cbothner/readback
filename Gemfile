# frozen_string_literal: true

source 'https://rubygems.org'

##################
# Infrastructure #
##################
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0-rc1'
# Heroku needs 12factor for logs and assets
gem 'rails_12factor', group: :production
# Use postgresql as the database for Active Record
gem 'pg'
# Don't use WEBBrick because it's slow
gem 'puma'
# Scheduling!
gem 'resque'
gem 'resque-scheduler'
gem 'resque_mailer'
# Cache
gem 'dalli'
gem 'kgio'
gem 'rack-cache'
# Queue
gem 'redis', '~> 3.0'
gem 'sidekiq'
# Monitoring
gem 'newrelic_rpm', group: :production
# File Storage
gem 'aws-sdk-s3', require: false
gem 'mini_magick'
# SSH
gem 'net-ssh'

##########
# Models #
##########
# Decorator pattern
gem 'draper'
# What are English times?
gem 'chronic'
# What are recurring times?!
gem 'ice_cube'

#####################
# View interpreters #
#####################
# Use HAML
gem 'haml'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1'
# Render PDFs with LaTeX
gem 'rails-latex'
# For markdown interpretation in show notes
gem 'redcarpet'
# For so I only have to write the emails once.
gem 'maildown'

##############
# JavaScript #
##############
# Webpacker for the npm ecosystem
gem 'webpacker', '~> 3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'json'

########################
# Forms and Validation #
########################
gem 'best_in_place', '= 3.0.1'
gem 'jc-validates_timeliness'

####################################
# Authentication and Authorization #
####################################
gem 'authority'
gem 'devise', '~> 4.0'
gem 'encrypted_strings'
gem 'rolify'

##############
# Production #
##############
group :production do
  gem 'lograge'
  gem 'memcachier'
end

###############
# Development #
###############
group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'factory_bot_rails'
  gem 'rspec-rails'

  # To identify database inefficiencies like n+1 queries and unused eager
  # loading
  gem 'bullet'

  gem 'seed_dump'

  gem 'guard'
  gem 'guard-rspec', require: false

  # Preview emails!
  gem 'letter_opener'
end

# To make console access better in development and on the production server
gem 'awesome_print'
gem 'table_print'

###########
# Testing #
###########
group :test do
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

ruby '2.5.0'
