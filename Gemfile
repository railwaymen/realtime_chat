# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 5.2.2'
gem 'sqlite3'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'haml-rails'
gem 'jwt', '~> 2.1.0'
gem 'pg'
gem 'redis'
gem 'anycable-rails'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'
gem 'procodile'
gem 'discard', '~> 1.0'
gem 'webpacker', '~> 4.0', '>= 4.0.7'
gem 'pundit'
gem 'blueprinter', '~> 0.18.0'
gem 'carrierwave', '>= 2.0.0.rc', '< 3.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  gem 'faker', '~> 1.9', '>= 1.9.3'
  gem 'json_spec', '~> 1.1', '>= 1.1.5'
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'shoulda-matchers', '~> 4.1'
  gem 'simplecov', '~> 0.16.1'
  gem 'rails-controller-testing'
  gem 'action-cable-testing'
end

group :development do
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'awesome_print'
  gem 'rubocop', require: false
  gem 'brakeman'
  gem 'bullet'
end
