source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include? '/'
  "https://github.com/#{repo_name}.git"
end

gem 'ruby_dep', '~> 1.4', require: 'ruby_dep/quiet'

gem 'bcrypt', '~> 3.1.7'
gem 'puma', '~> 3.7'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'validate_url'
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'graphql'
gem 'graphql-query-resolver'
gem 'search_object'
gem 'search_object_graphql'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'factory_bot_rails'
  gem 'graphiql-rails', '1.5.0'
  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
