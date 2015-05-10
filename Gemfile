source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.1'

# helper for handling of CSRF token
gem 'ng-rails-csrf', '~> 0.1.0'

gem 'bootstrap-sass', '~> 3.2.0' # http://bootstrapdocs.com/v3.2.0/docs/

# For using ActiveModel's 'has_secure_password'
gem 'bcrypt-ruby', '~> 3.1.2', require: 'bcrypt'

gem 'cancancan', '~> 1.9.2'

gem 'js-routes', '~> 0.9.7'

gem 'kaminari', '~> 0.15.1'

gem 'factory_girl_rails', '~> 4.2.1'
gem 'faker', '~> 1.1.2'

gem 'haml', '~> 4.0.5'

# For automating interaction with websites
gem 'mechanize', '~> 2.7.4.beta2', github: 'sparklemotion/mechanize', ref: '4a011394d57de3bedc7d0f608e4724d0bb9ad1d7'

gem 'chronic', '~> 0.10.2'

gem 'wannabe_bool', '~> 0.1.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

# Switch from SQLite to PostgreSQL for deployment to Heroku
# Based on http://railsapps.github.com/rails-heroku-tutorial.html
group :development, :test do
  gem 'rake', '~> 10.4.2'
  gem 'rspec-rails', '~> 3.0'
  gem 'minitest', '~> 5.3.3' # temporary workaround for "Warning: you should require 'minitest/autorun' instead."
  gem 'shoulda-matchers', '~> 2.5.0'
  gem 'rb-fsevent', '~> 0.9.4'
  gem 'rb-inotify', '~> 0.9.3', require: false
  gem 'awesome_print', '~> 1.2.0'
  gem 'timecop', '~> 0.7.1'
  # Debugging
  gem 'debase', '~> 0.1.0'
  gem 'ruby-debug-ide', '~> 0.4.22'
end

group :development do
  gem 'pry'
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'guard-livereload', '~> 2.1.2'
  gem 'rack-livereload', '~> 0.3.15'
end

group :test do
  gem 'webmock', '~> 1.18.0'
  gem 'vcr', '~> 2.9.2'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'launchy', '~> 2.3.0'
  gem 'poltergeist', '~> 1.6.0'
  gem 'selenium-webdriver', '~> 2.45.0'
  gem 'capybara-screenshot', '~> 1.0.7'
end

group :production do
  gem 'pg', '~> 0.17.1'
  gem 'thin', '~> 1.6.1'
  gem 'rails_12factor', '~> 0.0.2'
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

#gem 'coffee-script-redux-debugger', :git => 'git://github.com/JetBrains/coffee-script-redux-debugger.git'

gem 'angularjs-rails-resource', '~> 1.2.1'

gem 'eventmachine', '>= 1.0.4'

ruby '2.2.0'