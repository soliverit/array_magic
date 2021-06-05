class BinNumber
	def initialize
		@bits		= []
		@carrying	= false
	end
	def either? bit1, bit2
		bit1 == 1 || bit2 == 1
	end
	def pushBit bit1, bit2
		bit1, bit2 = bit1.round.to_i, bit2.round.to_i
		if bit1 == 1 && bit2 == 1
			if @carrying
				@bits	= [1].concat @bits
			else
				@carrying 	= true
				@bits		= [0].concat @bits
			end
		elsif either?(bit1, bit2)
			if @carrying
				@bits	= [0].concat @bits
			else
				@bits	= [1].concat @bits
			end
		else
			if @carrying
				@bits	= [1].concat @bits
				@carrying = false
			else
				@bits		= [0].concat @bits
			end
		end
	end
	def bits
		if @carrying
			@bits		= [1].concat @bits
		end
		@bits.clone
	end
	def print val1, val2, target
		puts "1:\t" + val1.to_s(2)
		puts "2:\t" + val2.to_s(2)
		puts "=:\t" + target.to_s(2)
		puts "?:\t" + bits.map(&:to_s).join
	end
end