# This file is merely for beginning the boot process
PADRINO_ROOT = File.dirname(__FILE__) + '/..' unless defined? PADRINO_ROOT
# At the moment we load it from lib
$LOAD_PATH.unshift PADRINO_ROOT + '/lib'
require 'padrino/framework'

# Loads the required files into the application
Padrino.load!