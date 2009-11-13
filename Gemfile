clear_sources
source 'http://gemcutter.org'

# Base requirements
gem 'sinatra_more'
gem 'rack-flash'
gem 'warden'
gem 'bcrypt-ruby', :require_as => 'bcrypt'

# Component requirements
gem 'haml'
gem 'hassle'
gem 'dm-core'
gem 'dm-validations'

# Testing requirements
only :test do
  gem 'mocha', :only => :testing
  gem 'bacon', :only => :testing
  gem 'rack-test', :require_as => 'rack/test', :only => :testing
end