# frozen_string_literal: true

def next?
  File.basename(__FILE__) == 'Gemfile.next'
end

source 'https://rubygems.org'

ruby '3.1.3'
# need to update this ASAP
gem 'rails', '6.0.5'

# Use Puma as the app server
gem 'puma'

# Security hole updates
# gem 'loofah', '2.10.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc'

# Temporary
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'psych', '< 4'

# This is the authen gem
gem 'devise', '4.8.0'
gem 'omniauth', '2.0.4'
gem 'autoprefixer-rails'
# TODO: Consider bootstrap gem instead... currently 4.5.0
gem 'bootstrap-sass'

gem 'stripe'

group :development do
  gem 'listen'
  gem 'spring'
  gem 'web-console', '3.7.0'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  # gem 'shoulda-matchers'
  # gem 'spring-commands-rspec'
  # gem 'webmock'
end

group :development, :test do
  gem 'bullet'
  gem 'bundler-audit'
  gem 'byebug'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :assets do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '4.2.0'
  # Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails', '5.0.0'
  gem 'sass-rails', '6.0.0'
end
