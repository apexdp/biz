# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :benchmark do
  gem 'benchmark-ipsa', '~> 0.2.0', require: false
  gem 'business_time',  '~> 0.9.0', require: false
  gem 'working_hours',  '~> 1.0',   require: false
end

group :ci do
  gem 'simplecov', '~> 0.16.0', require: false
end

group :development do
  gem 'bump',    '~> 0.7.0', require: false
  gem 'bundler', '~> 1.8',   require: false
end

group :ci, :development do
  gem 'rake',    '~> 12.0',   require: false
  gem 'rspec',   '~> 3.0',    require: false
  gem 'rubocop', '~> 0.62.0', require: false
end
