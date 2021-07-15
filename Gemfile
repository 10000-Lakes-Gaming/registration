def next?
  File.basename(__FILE__) == "Gemfile.next"
end

source 'https://rubygems.org'

ruby '~> 2.7.4'
gem 'rails', '5.2.6'

# Use Puma as the app server
gem 'puma'

# Security hole updates
gem 'loofah', '2.10.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

# This is the authen gem
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'devise', '4.8.0'
gem 'omniauth', '2.0.4'

gem 'stripe'

group :development do
  # This is the most current version we can use until we move to Rails 6
  gem 'web-console', '3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'simplecov', require: false
  # gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-rails'
  # gem 'shoulda-matchers'
  # gem 'spring-commands-rspec'
  # gem 'webmock'
end

group :development, :test do
  gem 'bullet'
  gem 'bundler-audit'
  gem 'byebug'
  gem 'rubocop', '1.18.3', require: false
  gem 'rubocop-performance', '1.11.4'
  gem 'rubocop-rails', '2.11.3'
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
