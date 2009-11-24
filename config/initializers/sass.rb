# Enables support for SASS template reloading for rack.
# See http://nex-3.com/posts/88-sass-supports-rack for more details.

module SassInitializer
  def self.registered(app)
    require 'sass/plugin/rack'
    app.use Sass::Plugin::Rack
  end
end