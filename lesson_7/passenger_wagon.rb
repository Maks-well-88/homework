require_relative 'wagon'

class PassengerWagon < Wagon
	WAGON_TYPE = :passenger

	def initialize(volume)
		super(WAGON_TYPE, volume)
	end
end