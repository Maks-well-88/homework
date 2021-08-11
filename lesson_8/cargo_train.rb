require_relative 'train'
require_relative 'module_manufacturer'

class CargoTrain < Train
	include Manufacturer

	TRAIN_TYPE = :cargo

	def initialize(number)
		super(number, TRAIN_TYPE)
	end
end