def next?
  File.basename(__FILE__) == "Gemfile.next"
end

source 'https://rubygems.org'
ruby '~> 2.6.3'

gem 'rails_12factor'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# if next?
  gem 'rails', '~> 5.2.3'
# else
#   gem 'rails', '~>  5.0'
# end

# Security hole updates
gem 'rails-html-sanitizer', '~> 1.0.4'
gem 'loofah', '~> 2.2.1 '

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# security problem in version 1.7.1
gem 'nokogiri', '~> 1.10.3'

# This is the authen gem
gem 'devise', '~> 4.6.2'
gem 'omniauth', '~> 1.9.0'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'autoprefixer-rails'

gem 'stripe'
gem 'bundler-audit'

group :development do
  gem "capistrano", "~> 3.4"
# Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
# This probably belons in development
  gem 'thin'
  # DUAL boots
  # gem "ten_years_rails",
  #     git: "https://github.com/fastruby/ten_years_rails_conf_2018.git"
end

group :test do
  gem 'simplecov', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'sqlite3', '~> 1.3.13'
  # Use SCSS for stylesheets
  gem 'minitest-reporters'
  gem 'minitest'
end


group :production do
  gem 'pg'
end

group :assets do
# Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails', '~> 5.0.0'
  gem 'sass-rails', '~> 5.0.7'

end

