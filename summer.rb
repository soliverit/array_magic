##
# Includes
##
# Native
require "./ruby/summer.rb"

### Test###
machine 			= Summer.new
machine.maxError	= 0.0000
machine.train
machine.test