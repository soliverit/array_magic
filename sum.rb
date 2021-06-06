##
# Includes
##
# Native
require "./shared/summer.rb"

### Test###
machine 			= Summer.new
machine.maxError	= 0.0000
machine.train
machine.test