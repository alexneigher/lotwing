source 'https://rubygems.org'

ruby '2.6.5'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
# Use Postgres as the database for Active Record
gem 'pg', '~> 0.20'

gem 'barby'
gem 'chunky_png'

gem 'kaminari'

gem 'acts_as_paranoid'

gem 'dalli'

gem 'rack-cors', :require => 'rack/cors'
gem 'jwt'
gem 'simple_command'

gem 'stripe'

gem 'airbrake'
# Use Puma as the app server
gem 'puma', '~> 3.7'

# Official Geokit Gem. Geokit gem provides geocoding and distance/heading calculations. Pair with the geokit-rails plugin for full-fledged location-based app functionality.
gem 'geokit'

#A Ruby gem to load environment variables from `.env`.
gem 'dotenv-rails'

gem "lograge"

# Generate PDF's from html
gem 'wicked_pdf', '~> 1.1'
gem 'wkhtmltopdf-binary', '0.12.3' #TODO this can be bumped once a fix is determined (AFTER 6/11/2018)

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# Track changes to your models' data. Good for auditing or versioning.
gem 'paper_trail'

# A gem to automate using jQuery with Rails
gem 'jquery-rails'

gem 'jquery-ui-rails'

# the font-awesome font bundled as an asset for the rails asset pipeline
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Bootstrap 4 Ruby Gem for Rails / Sprockets and Compass.
gem "bootstrap", ">= 4.3.1"

# Better Markup for views
gem 'haml'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Flexible authentication solution for Rails with Warden.
gem "devise", ">= 4.7.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem "letter_opener"

  #Rails >= 3 pry initializer
  gem 'pry-rails'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
