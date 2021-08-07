require_relative 'wagon'

class CargoWagon < Wagon
	WAGON_TYPE = :cargo
	
	def initialize(volume)
		super(WAGON_TYPE, volume)
	end
end