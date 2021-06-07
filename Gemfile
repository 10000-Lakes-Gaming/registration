def next?
  File.basename(__FILE__) == "Gemfile.next"
end

source 'https://rubygems.org'
ruby '~> 2.7.1'

gem 'rails_12factor'

gem 'rails', '5.2.6'

# Use Puma as the app server
gem 'puma', '4.3.8'

# Security hole updates
gem 'loofah', '2.6.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '1.1.0', group: :doc

# security problem in version 1.7.1
gem 'nokogiri', '~> 1.11'

# This is the authen gem
gem 'devise', '4.7.2'
gem 'omniauth', '2.0.4'
# TODO: Consider bootstrap gem instead... currently 4.5.0
gem 'bootstrap-sass', '3.4.1'
gem 'autoprefixer-rails'

gem 'stripe'
gem 'bundler-audit'

group :development do
  gem "capistrano", "~> 3.4"
# Access an IRB console on exception pages or by using <%= console %> in views
# This is the most current version we can use until we move to Rails 6
  gem 'web-console', '3.7.0'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'simplecov', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '4.0.1'
  gem 'sqlite3'
  # Use SCSS for stylesheets
  # TODO: remove when we have all brought over to rspec
  gem 'minitest-reporters'
  gem 'minitest'
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

