require_relative 'wagon'

class PassengerWagon < Wagon
	
	TYPE = :passenger
	UNIT = 'мест'

	def initialize(place)
		super(TYPE, place)
	end

	def take_place(amount=1)
		raise 'Нельзя занять больше одного места за раз!' if amount > 1
		@taken_place += amount if free_place >= amount
	end
end