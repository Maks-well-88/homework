require_relative 'train'

class PassengerTrain < Train
	TRAIN_TYPE = :passenger

	def initialize(number)
		super(number, TRAIN_TYPE)
	end
end