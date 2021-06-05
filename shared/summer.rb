# Native
require "ruby-fann"
# Project
require_relative "./array_magic_base.rb"
require_relative "./bin_number.rb"

##
# Summer - A neural network for determining the sum of an positive integer array's values
#
# Method:
#	- Iterate over the values in the array
#	- Convert the total (0 at start) and next value to base 2 strings
#	- Convert strings to arrays of 0s and 1s representing the base 2 bits
#	- Pad the array with the fewest bits with preceding 0s to match the lengths
#	- For each index between 0 and arrays' length - 1
#		- Invert the index so the method works left to right, lowest to highest
#		- Take the bit from total[index] and current value[index] and classify
#		  them as value 0 [0,0], 1 [0,1] / [1, 0] or 10 [1, 1]
#		- Send the classes to the BinNumber that will use Boolean rules to
#	      determine the next bit or two bits' states
#	- That's it. Pass arrays of integers to .sum and you'll get a BinNumber
#	  back. BinNumber's have a "to_i" for base 10 and "bits" method for base 2 fomrmats
##
class Summer < ArrayMagicBase	
	##
	# Training data. 
	#
	# The data is static and very small so it's just stored as static
	##
	TRAINING_DATA = {
			X: [[0, 0], [0, 1], [1, 0], [1,1]],
			Y: [[0, 0], [0, 1], [0, 1], [1, 1]]
	}
	##
	# Overriden! (Needs to be replaced / more or less an abstract method)
	#
	# Generate training and if necessary, test samples
	#
	# Summer is trained on a small finite set of samples akin to the XOR
	# training data. In this case, the data is prepared here for consistency
	# with other ArrayMagicBase classes
	#
	# Note: Since `doTraining` has to be overriden as well, the data created
	# 		here can be stored as any @ instance variable but. In the spirit
	#		the project, @xData{train:[], test:[]} @yData{train:[], test:[]}
	#		is preferred.
	#
	# See prepareData in "./shared/array_magic_base.rb" for more information
	##
	def prepareData
		@xData 	= {train: TRAINING_DATA[:X]}
		@yData	= {train: TRAINING_DATA[:Y]}
	end
	##
	#  Overriden! (Needs to be replaced / more or less an abstract method)
	#
	# Do training
	#
	# Train with any ML learner you want' just make sure to return their
	# trained machine.
	#
	# See doTraining in "./shared/array_magic_base.rb" for more information.
	##
	def doTraining
		##
		# Call the internal pre-training function to do stuff like data prep and whatnot
		##
		train	= RubyFann::TrainData.new(inputs: @xData[:train], desired_outputs: @yData[:train])
		machine	= RubyFann::Standard.new(num_inputs: 2, hidden_neurons:[], num_outputs: 2)
		machine.train_on_data(train, @iterations, @reportSteps, 0.0) 
		# Return the trained model !!!! Super important. Every doTraining should return the machine
		machine
	end
	##
	# Convert an integer 0 <= integer to a base 2 bit array
	#
	# value:	integer 0 <= value
	#
	# output:	Array of 0s and 1s representing the bits of base 2 of value ([1 ,0, 1] = 5, for example)
	##
	def valueToBits value
		# Convert to base 2 string, split into integer array
		value.to_s(2).split("").map{|val| val.to_i}
	end
	##
	# Pad an array with 0s to a specified length
	#
	# Ruby to_s(2) for integers shaves off leading 0s. This method
	# puts them back.
	#
	# bitArray:		Input array [hopefully] of 0 and 1 values
	# length:		Target array length
	#
	# output:		An array with "length" elements
	##
	def padBitArray bitArray, length	
		# Create an array of 0s the length difference, concat current array to it
		(0...(length - bitArray.length)).map{0}.concat bitArray
	end
	##
	#	Add two integers 0 <= integer
	#
	#	val1:	integer
	#	val2:	integer
	#
	#	output:	val1 + val2 as BinNumber
	##
	def add val1, val2
		##
		# Translate input numbers into base 2 bit arrays the same length
		##
		val1Binary	= valueToBits val1
		val2Binary	= valueToBits val2
		bitSize		= [val1Binary.length, val2Binary.length].max
		val1Binary	= padBitArray val1Binary, bitSize
		val2Binary	= padBitArray val2Binary, bitSize
		##
		# Iterate over bit input values' bit pairs and add their predicted 
		# bool state to the output BinNumber
		##
		results		= BinNumber.new
		(0...val1Binary.length).each{|idx|
			# Inverted the index so we're working with 2^idx from smallest to largest
			idx 		= val1Binary.length - 1 -idx
			# Do prediction  / classify
			prediction 	= @machine.run([val1Binary[idx], val2Binary[idx]]).map{|val| val.round.to_i}
			# Use prediction/classification to add a new bit to the binary number (BinNumber)
			results.pushBit prediction[0], prediction[1]
		}
		# Send it back to the caller
		results
	end
	##
	# Sum an array's value
	#
	# input:	An Array of integers 0 <= integer
	#
	# output:	A BinNumber object "./shared/bin_number". BinNumber instances
	#			can provide the bit array or the integer value using "bits"
	#			and "to_i"
	##
	def sum input
		##
		# Iterate over each input value
		##
		total 	= 0
		output	= false
		input.each{|i| 
			# Keep the last result, returned to the caller at the end
			output 	= add( total, i)
			# Keep tabs on the total at step i
			total 	= output.to_i
		}
		# Send it back to the caller
		output
	end
end