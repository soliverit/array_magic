class ArrayMagicBase
	attr_accessor :trainTestRatio, :nSamples, :reportSteps, :iterations, :maxError, :silent, :nInputs
	DEFAULT_ITERATIONS		= 100
	DEFAULT_N_SAMPLES		= 1000
	DEFAULT_TRAIN_TEST		= 0.5
	DEFAULT_REPORT_STEPS	= 100
	DEFAULT_MAX_ERROR		= 0.1
	DEFAULT_N_INPUTS		= 2
	def initialize 
		@reportSteps	= DEFAULT_REPORT_STEPS
		@nSamples		= DEFAULT_N_SAMPLES
		@trainTestRatio	= DEFAULT_TRAIN_TEST
		@iterations		= DEFAULT_ITERATIONS
		@maxError		= DEFAULT_MAX_ERROR
		@silent			= false
		@nInputs		= DEFAULT_N_INPUTS
	end
	def prepareData
		raise "ArrayMagicBase:prepareData hasn't been overridden"
	end
protected 
	def preTrain
		prepareData
		describe unless @silent
	end
	def describe
		puts """
		\t##
		\t# MaxError:         #{@maxError}
		\t# No. Samples:      #{@nSamples}
		\t# Iterations:       #{@iterations}
		\t# train/test ratio: #{@trainTestRatio}
		\t##
		"""
	end
end