require "./ruby/is_sorted.rb"

machine 			= IsSorted.new
machine.nInputs 	= 128
machine.nSamples	= 25000
machine.iterations	= 50
# machine.limit		= 1000000
machine.train
machine.test

# # Data stuff #
# X, Y, LIST_LENGTH, MAX_MSE, ITERATIONS, N_SAMPLES, LIMIT, REP_STEPS	= [], [], 128, 0.01, 50, 25000, 10000000.0,  2
# # Generate train/test data
# (0...N_SAMPLES).map{|idx| #Probably enough data
	# record			= (0...LIST_LENGTH).map{rand(LIMIT) / LIMIT}	# 128 list 0 <= val <= 1,000,000
	# record			= record.sort{|a,b| a <=> b} if idx % 2 == 0			# Make half the data sorted
	# X.push record
	# Y.push([record == record.sort{|a,b| a<=>b} ? 1.0 : 0.0])				# Figure out target 1 sorted, 0 unsorted
# }
# # Split the data	
# Xdata	= {Xtrain: X[0, X.length / 2], Xtest: X[X.length / 2, X.length - 1]}
# Ydata	= {Ytrain: Y[0, Y.length / 2], Ytest: X[Y.length / 2, Y.length - 1]}

# ### Train Ann ###
# train	=  RubyFann::TrainData.new(inputs: Xdata[:Xtrain], desired_outputs: Ydata[:Ytrain])
# fann 	= RubyFann::Standard.new(num_inputs: LIST_LENGTH, hidden_neurons:[2], num_outputs: 1)
# fann.train_on_data(train, ITERATIONS, REP_STEPS, MAX_MSE) 

# # Score it
# winLoss = {win: 0, loss: 0, sorted: 0, unsorted: 0}
# Xdata[:Xtest].each{|test|
	# sorted = test.sort{|a,b| a<=> b}
	# prediction	= fann.run(test).first
	# if prediction > 0.69 && test == sorted
		# winLoss[:win] 		+= 1
		# winLoss[:sorted]	+= 1
	# elsif test != sorted
		# winLoss[:win] 		+= 1
		# winLoss[:unsorted]	+= 1
	# else
		# winLoss[:loss] 		+= 1
	# end
# }
# puts "Iterations: #{ITERATIONS}\nMAX_MSE:    #{MAX_MSE}\n\t#{winLoss}" # proof