require 'tilt'
require 'padrino-core/support_lite'
Dir[File.dirname(__FILE__) + '/padrino-mailer/**/*.rb'].each { |file| require file }

module Padrino
  module Mailer
    def self.registered(app)
      MailerBase::views_path = app.views
    end
  end  
end