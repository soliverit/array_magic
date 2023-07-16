class BinNumber
	def initialize
		# Array of bits extended by the "pushBit" function
		@bits		= []
		# Was the last bit added by "pushBit" 
		@carrying	= false
	end
	##
	# Take the two classifications for bit1 and bit2 and
	# convert to a single bit value that's part of the 
	# number the BinNumber represents.
	##
	def pushBit bit1, bit2
		# Round inputs to 0/1 just in case
		bit1, bit2 = bit1.round.to_i, bit2.round.to_i
		##
		# Bit selection : [0, 0] = 0, [1, 0] or [0, 1] = [0, 1], [1, 1] = carry the 1
		##
		# when [1, 1]
		if bit1 == 1 && bit2 == 1
			if @carrying
				@bits	= [1].concat @bits
			else
				@carrying 	= true
				@bits		= [0].concat @bits
			end
		# when [0, 1] or [1, 0]
		elsif bit1 == 1 || bit2 == 1
			if @carrying
				@bits	= [0].concat @bits
			else
				@bits	= [1].concat @bits
			end
		# when [0, 0]
		else
			if @carrying
				@bits	= [1].concat @bits
				@carrying = false
			else
				@bits		= [0].concat @bits
			end
		end
	end
	##
	# Generate the base 2 bit array 
	##
	def bits
		# Get a safe copy of the @bits array
		bts = @bits.clone
		##
		# If carrying and not [HACK catch the pattern tha breaks it by adding an extrax 1]
		##
		if @carrying && @bits[0,4] != [1, 0, 0, 0]
			bts		= [1].concat @bits
		end
		# Return to the caller
		bts
	end
	##
	# Convert the bit array from base 2 to base 10
	##
	def to_i
		bits.map(&:to_s).join.to_i(2)
	end
	def print val1, val2, target
		puts "1:\t" + val1.to_s(2)
		puts "2:\t" + val2.to_s(2)
		puts "=:\t" + target.to_s(2)
		puts "?:\t" + bits.map(&:to_s).join
	end
end