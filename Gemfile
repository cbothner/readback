source 'https://rubygems.org'

##################
# Infrastructure #
##################
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Heroku needs 12factor for logs and assets
gem 'rails_12factor', group: :production
# Use postgresql as the database for Active Record
gem 'pg'
# Don't use WEBBrick because it's slow
gem 'puma'
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
gem 'coffee-rails', '~> 4.1.0'
# Render PDFs with LaTeX
gem 'rails-latex'
# For markdown interpretation in show notes
gem 'redcarpet'


##############
# JavaScript #
##############
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


########################
# Forms and Validation #
########################
gem 'best_in_place', '~> 3.0.1'
gem 'jc-validates_timeliness'


####################################
# Authentication and Authorization #
####################################
gem 'devise'
gem 'authority'
gem 'rolify'


###############
# Development #
###############
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'factory_girl_rails', require: false

  # To identify database inefficiencies like n+1 queries and unused eager
  # loading
  gem 'bullet'

  gem 'seed_dump'

  gem 'thor', '0.19.1'
  gem 'guard'
  gem 'guard-rspec', require: false
end


###########
# Testing #
###########
group :test do
  gem 'faker'
  gem 'shoulda-matchers'
end

ruby "2.2.2"
