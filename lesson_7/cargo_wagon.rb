require_relative 'wagon'

class CargoWagon < Wagon
	
	TYPE = :cargo
	UNIT = 'м3'
	
	def initialize(place)
		super(TYPE, place)
	end

	def take_place(amount)
		@taken_place += amount if free_place >= amount
	end
end