##
# Includes
##
# Project
require "./ruby/sorter.rb"
##
# Do stuff here
##
# Some test data
TESTS = [
	[-10, 3, -100, -105],
	[6, 5, -4, 3, 2, 1],
	[20, 21, 31, 5000, 5001, 5999,1000],
	[484, 83482, -12309, -23, 0],
]
# Make a sorter
sorter  = Sorter.new
# Test each record
TESTS.each{|input|
	# Get the predicted sort order
	sorted 	= sorter.sort input
	# Get the target sort order
	target	= (input.sort{|a,b| a<=>b} == sorted)
	# Dirty console print input, output and expected
	puts "---\nInput:    " +input.to_s + "\nProduced: " + sorted.to_s + "\nSuccess:  " + target.to_s
}
