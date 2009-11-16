# Padrino delegator is a class usefull for delegate certain methods to another class
#
# Usually we delegate :get, :post, :delete, :put etc from Controllers to their Sinatra Application
# We can delegate also for example route mapping methods (:map) from i.e. Urls to their Sinatra Application
#
module Padrino
  class Delegator
    def delegate(method_name)
      @method_name = method_name
      self
    end

    def to(klass)
      (class << self; self; end).class_eval <<-RUBY
      def #{@method_name}(*args, &block)
        #{klass}.send(#{@method_name.inspect}, *args, &block)
      end
      private #{@method_name.inspect}
      RUBY
    end
  end
end


