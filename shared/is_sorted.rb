#Native
require "ruby-fann"
#Project
require_relative "./array_magic_base.rb"
class IsSorted < ArrayMagicBase
	##
	# Prepare @xData and @yData for training / testing
	#
	# doTraining shuold always be using @xData[:train], @yData[:train]
	# as training data.
	##
	def prepareData
		##
		# For @nSamples iterations, generate sample and sorted state label
		##
		#Complete X and Y datasets. To be split later on
		x, y = [], []
		(0...@nSamples).map{|idx| #Probably enough data
			##
			# Create sample an add it to the complete X dataset
			##
			# Generate the sample. Will rarely if ever generaate a sorted list
			record			= (0...@nInputs).map{rand(@limit)}	# 128 list 0 <= val <= 1,000,000
			# Balance sorted labels with unsorted by sorting half of the samples
			record			= record.sort{|a,b| a <=> b} if idx % 2 == 0			# Make half the data sorted
			# Add the record to the complete X dataset
			x.push record
			# Classify the sample as sorted or unsorted
			y.push([record == record.sort{|a,b| a<=>b} ? 1.0 : 0.0])				# Figure out target 1 sorted, 0 unsorted
		}
		# Split the data	
		@xData	= {train: x[0, x.length / 2], test: x[x.length / 2, x.length - 1]}
		@yData	= {train: y[0, y.length / 2], test: y[y.length / 2, y.length - 1]}
	end
	##
	# Train the isSorted? machine [Abstract method (must be made)
	##
	def doTraining
		# Ruby fan uses its own special data structure. 2D Array for both X and Y data
		train		= RubyFann::TrainData.new(inputs: @xData[:train], desired_outputs: @yData[:train])
		# Train
		machine	= RubyFann::Standard.new(num_inputs: @nInputs, hidden_neurons:[2], num_outputs: 1)
		machine.train_on_data(train, @iterations, @reportSteps, @maxError) 
		
		machine
	end
	##
	# Test the model: Prove that it works
	#
	# Proviing this works is straightforward. Just create
	# an array of integers (try floats next...), classify
	# it with the machine, sort the original and compare
	# results.
	##
	def test
		##
		# Possible outcomes for each test. Do all tests and count the outcome
		##
		winLoss = {win: 0, loss: 0, sorted: 0, unsorted: 0}
		@xData[:test].each{|test|
			#Get the truth
			sorted 		= test.sort{|a,b| a <=> b}
			#Take an educated guess
			prediction	= @machine.run(test).first.round
			##
			# Record outcomes
			##
			#If it is classed as sorted and is sorted
			if prediction == 1 && test == sorted 
				winLoss[:win] 		+= 1
				winLoss[:sorted]	+= 1
			#If it's classed as unsorted and is unsorted
			elsif prediction == 0 && test != sorted
				winLoss[:win] 		+= 1
				winLoss[:unsorted]	+= 1
			#A loos. You've broke something somewhere (probably)
			else
				winLoss[:loss] 		+= 1
			end
		}
		#Print the results
		puts "Iterations: #{@iterations}\nMAX_MSE:    #{@maxError}\n\t#{winLoss}" # proof
	end
	
end
