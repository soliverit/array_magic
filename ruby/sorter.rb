#Native
require "ruby-fann"
#Project
require_relative "./array_magic_base.rb"
require_relative "./is_sorted.rb"
##
# Sorter: An array sorter using the IsSorted model
#
# Sorter is designed to tell an array of length @nInputs is
# sorted. This model reduces @nInputs to two which will 
# determine whether a pair is sorted or not. 
#
# Method:
#	- Call Sorter.sort method, passing a numeric array
#	- Clone the input array
#	- While !finished:
#		- For index = 1 to index = input array length - 1:
#			- Pass input[index - 1], input[index] to IsSorted.predict
#			- If the prediction = true (1):
#				- Switch input[index - 1] and input[index]
#				- Record that a sort event occurred
#		- If no sort event is recorded:
#			- Set finished == true (Ending the sort)
#	- Send the result back to the caller
##
class Sorter
	##
	# Get started: Create a new sorter with 2 inputs and train it
	##
	def initialize 
		@sorter	= IsSorted.new
		@sorter.nInputs = 2
		@sorter.train
	end
	##
	# Sort an array (of integers)
	##
	def sort array
		array = array.clone
		finished = false
		##
		# Ok, should be an easy one. Compare the current and next value
		##
		while !finished
			#Flag to track whether an iteration edited the array
			wasSorted	= false
			# Compare value pairs from input array
			(1...array.length).each{|idx|
				# Get the target values
				currentValue		= array[idx]
				previousValue		= array[idx - 1]
				# Figure out if the previous and current value arein the correct order
				currentVsPrevious	= @sorter.predict([previousValue, currentValue]).first.round
				# If they aren't (as best we know at least), swap the two values
				if currentVsPrevious == 0
					array[idx]		= previousValue
					array[idx - 1]	= currentValue
					wasSorted		= true
				end
			}
			# If no sort action was taken, the array must be sorted.
			finished = !wasSorted
		end
		# Return to caller
		array
	end
end