source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

group :test do
  gem 'sqlite3'

  gem 'rb-inotify', :require => false
  gem 'guard-rspec'

  gem 'capybara', '~> 2.0.3'
  # apt-get install libxslt-dev libxml2-dev
  gem 'capybara-webkit' #,:git => 'https://github.com/thoughtbot/capybara-webkit.git'
  # apt-get install libqt4-dev
  
  gem 'database_cleaner'

  gem 'launchy'
  gem 'faker'
end

#gem 'rack-mini-profiler'

group :development, :test do
  gem 'rspec-rails'

  gem 'factory_girl_rails'

  gem 'webrick' # Bug in regular webrick
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'bootstrap-sass', '~> 2.2.2.0'
  # http://railsapps.github.com/twitter-bootstrap-rails.html
end
gem 'quiet_assets', :group => :development

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
# gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'rails-i18n'


gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
# rails generate simple_form:install --bootstrap
# rails generate client_side_validations:install
# //= require rails.validations
# //= require rails.validations.simple_form
# rails generate client_side_validations:copy_assets
gem 'cocoon'

gem 'prawn'
gem 'prawn_rails'
