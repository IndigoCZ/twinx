source 'https://rubygems.org'

gem 'rails', '~> 4.0.2'

gem 'pg'
#apt-get install libpq-dev

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  # apt-get install libxslt-dev libxml2-dev

  gem 'database_cleaner'

  gem 'faker'
end

group :development, :test do
  gem 'rspec-rails'

  gem 'factory_girl_rails'

  gem 'webrick' # Bug in regular webrick
end

group :production do
  gem 'unicorn'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'

# apt-get install nodejs
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 2.0'

gem 'bootstrap-sass', '~> 3.0.2'

# http://railsapps.github.com/twitter-bootstrap-rails.html

gem 'quiet_assets', :group => :development

gem 'jquery-rails'

gem 'rails-i18n'

gem 'simple_form', "~> 3.0.0"
#gem 'client_side_validations'
#gem 'client_side_validations-simple_form'
# rails generate simple_form:install --bootstrap
# rails generate client_side_validations:install
# //= require rails.validations
# //= require rails.validations.simple_form
# rails generate client_side_validations:copy_assets

gem 'cocoon'

gem 'prawn', "~> 0.12.0"
gem 'prawn_rails'

gem 'coveralls', require: false

gem 'rails_admin', "~> 0.6"
#gem 'rails_admin', github: 'sferik/rails_admin'

gem "devise", "~> 3.1"
#gem "turbolinks"
#gem "jquery-turbolinks"
