# This file is merely for beginning the boot process
PADRINO_ROOT = File.dirname(__FILE__) + '/..' unless defined? PADRINO_ROOT

# At the moment we load it from lib
Dir[PADRINO_ROOT + "/vendor/padrino/**/lib"].each do |gem|
  $LOAD_PATH.unshift gem
end
require 'padrino'

# Loads the required files into the application
Padrino.load!