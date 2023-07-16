# Native
require "ruby-fann"
# Project
require_relative "./array_magic_base.rb"

##
# Meaner - A neural network for determining the mean of an positive integer array's values
#
# Method:
##
class Meaner < ArrayMagicBase	

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
	MAX_VALUE	= 2**16
	LIST_LENGTH	= 5
	def prepareData
		@xData 	= {train: []}
		@yData	= {train: []}
		(0...@nSamples).each{
			values	= (0...LIST_LENGTH).map{rand(MAX_VALUE).to_f  / MAX_VALUE}
			@xData[:train].push values
			@yData[:train].push [values.sum / values.length]
		}
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
		machine	= RubyFann::Standard.new(
			num_inputs: LIST_LENGTH, 
			hidden_neurons: [LIST_LENGTH],#(0...LIST_LENGTH).map{LIST_LENGTH}, 
			num_outputs: 1
		)
		machine.train_on_data(train, @iterations, @reportSteps, @maxError) 
		# Return the trained model !!!! Super important. Every doTraining should return the machine
		machine
	end
	##
	#	Add two integers 0 <= integer
	#
	#	val1:	integer
	#	val2:	integer
	#
	#	output:	val1 + val2 as BinNumber
	##
	def mean val1, val2
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
		result		= BinNumber.new
		(0...val1Binary.length).each{|idx|
			# Inverted the index so we're working with 2^idx from smallest to largest
			idx 		= val1Binary.length - 1 -idx
			# Do prediction  / classify
			prediction 	= @machine.run([val1Binary[idx], val2Binary[idx]]).map{|val| val.round.to_i}
			# Use prediction/classification to add a new bit to the binary number (BinNumber)
			result.pushBit prediction[0], prediction[1]
		}
		# Send it back to the caller
		result
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
	def mean input
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
	##
	# !Overridden (Abstract'ish. Only needs overwritten if you need it)
	#
	# Run a few tests and print the results to the console
	##
	def test
		##
		# Do 10 test summing arrays with 10 random values
		##
		nTests			= 3
		valuesLength	= 10
		(0..nTests).each{|testIDX|
			values	= (0...LIST_LENGTH).map{rand(MAX_VALUE).to_f / MAX_VALUE}
			v2		= values.map{|v| v * MAX_VALUE}
			res		= values.sum / values.length
			puts "#{values} =#{MAX_VALUE / res} - #{MAX_VALUE / @machine.run(values).first}"
		}
	end
end