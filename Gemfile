# -*- coding: utf-8 -*-
source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
gem 'quiet_assets'
gem 'activerecord-session_store'

# Temporarily removing until eventmachine compiles on OSX for Ruby 2.2.1
gem 'thin'
# Admin Interface
gem 'rails_admin'

# Use SCSS for stylesheets
gem 'sass-rails', '=5.0.0.beta1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Needed for default layouts
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'underscore-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'devise'#, git: 'https://github.com/plataformatec/devise.git', :branch => 'lm-rails-4-2'
gem 'haml-rails'
gem 'bootstrap-sass'

group :production do
# Uncomment this for Heroku
  gem 'rails_12factor'

  gem 'pg'
  gem 'activerecord-postgresql-adapter'
end

gem 'therubyracer'
gem 'less-rails'

group :development do
  # Use pg as the database for Active Record
  gem 'pg'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'web-console'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
end

#testing with rspec

group :test do
  gem 'shoulda-matchers'

  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem "factory_girl_rails"
  gem 'database_cleaner'
  gem "email_spec"
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
end

# Integrations

gem 'pokitdok-ruby'
