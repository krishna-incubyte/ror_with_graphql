source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.0.3'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'tzinfo-data', platforms: %i[ windows jruby ]
gem 'bootsnap', require: false
gem 'thruster', require: false
gem 'graphql', "~> 2.6"

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'vcr'
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'rspec-graphql_matchers'
  gem 'pry'
  gem 'pry-rails'
  gem "pry-nav"
  gem "pry-doc"
  gem 'ostruct'
  gem 'simplecov'
end

group :development do
  gem 'annotaterb'
  gem 'faker'
  gem 'graphiql-rails'
end
