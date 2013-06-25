source 'https://rubygems.org'

gem 'rails', '4.0.0'

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

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails',   github: 'rails/sass-rails'
gem 'coffee-rails', github: 'rails/coffee-rails'

# apt-get install nodejs
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.3.0'

gem 'bootstrap-sass', '~> 2.3.2.0'
# http://railsapps.github.com/twitter-bootstrap-rails.html

gem 'quiet_assets', :group => :development

gem 'jquery-rails'

gem 'rails-i18n'

gem 'simple_form', github: 'plataformatec/simple_form'
#gem 'client_side_validations'
#gem 'client_side_validations-simple_form'
# rails generate simple_form:install --bootstrap
# rails generate client_side_validations:install
# //= require rails.validations
# //= require rails.validations.simple_form
# rails generate client_side_validations:copy_assets

#gem 'cocoon'

gem 'prawn'
gem 'prawn_rails'

gem 'coveralls', require: false

#gem 'rails_admin', github: 'sferik/rails_admin'


gem "devise", "~> 3.0.0.rc"
gem "turbolinks"
gem "jquery-turbolinks"
