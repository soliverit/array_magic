##
# Includes
##
# Native
require "ruby-fann"
# Project
require "./shared/array_magic_base.rb"
require "./shared/bin_number.rb"

##
##
class Summer < ArrayMagicBase
	# limit:	Integer upper limit for training data values
	attr_accessor :limit, :bitSize, :silent, :batchSize, :lossFunc
	def initialize
		super
	end
	##
	# Pad a bit string with preceding zeroes up to the Model number of bit @bitSize
	#
	# str:	String representing an integer in binary
	#
	# Ouptput:	String input padded with preceding zeores to @bitSize length
	##
	def padBitString str
		while str.length < @bitSize
			str = "0" + str
		end
		str
	end
	def inputBitLength 
		@bitSize #* @nInputs
	end
	def prepareData	
		##
		# Split the data into test and train samples
		##
		@xData			= {
			train: [[0, 0], [0, 1], [1, 0], [1,1]]
		}
		@yData	= {	 
			train: [[0, 0], [0, 1], [0, 1], [1, 1]]
		}
	end
	def train
		##
		# Call the internal pre-training function to do stuff like data prep and whatnot
		##
		preTrain
		train		= RubyFann::TrainData.new(inputs: @xData[:train], desired_outputs: @yData[:train])
		@machine	= RubyFann::Standard.new(num_inputs: 2, hidden_neurons:[], num_outputs: 2)
		@machine.train_on_data(train, @iterations, @reportSteps, @maxError) 
	end
	def valueToBits value
		value.to_s(2).split("").map{|val| val.to_i}
	end
	def padBitArray bitArray, length	
		(0...(length - bitArray.length)).map{0}.concat bitArray
	end
	def predict val1, val2
		##
		# Translate input numbers into base 2 bit arrays the same length
		##
		val1Binary	= valueToBits val1
		val2Binary	= valueToBits val2
		bitSize		= [val1Binary.length, val2Binary.length].max
		val1Binary	= padBitArray val1Binary, bitSize
		val2Binary	= padBitArray val2Binary, bitSize
		##
		# Iterate over bit input values' bit pairs and add their predicted  bool state to the output BinNumber
		##
		results		= BinNumber.new
		(0...val1Binary.length).each{|idx|
			idx 		= val1Binary.length - 1 -idx
			prediction 	= @machine.run([val1Binary[idx], val2Binary[idx]]).map{|val| val.round.to_i}
			results.pushBit prediction[0], prediction[1]
		}
		results
	end

end

machine 			= Summer.new
machine.maxError	= 0.0000
machine.train

### Test###

(0..10).each{|idx|
	val1	=  rand(100000)
	val2	=  rand(100000)
	result = machine.predict val1, val2 
	result.print val1, val2, (val1 + val2)
	exit
}