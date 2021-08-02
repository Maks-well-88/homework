require_relative 'module_manufacturer'
require_relative 'instance_counter'

class Train
	include Manufacturer
	include InstanceCounter

	attr_accessor :speed, :wagons, :current_point, :next_station, :previous_station
	attr_reader :number, :type

	@@trains = []

	def self.find(number)
		@@trains.find { |train| puts train if train.number == number }
	end

	def initialize(number = 'AB12C88-21', type)
		@number = number
		@type = type
		@wagons = []
		@speed = 0
		self.class.save_trains(self)
		count_copies
	end

	def take_route(route)
		@route = route
		self.current_point = route.list.first
	end

	def move_fwd
		point = @route.list.index(current_point)
		point += 1
		self.current_point = @route.list[point]
		self.next_station = @route.list[point + 1]
	end

	def move_back
		point = @route.list.index(current_point)
		point -= 1
		self.current_point = @route.list[point]
		self.previous_station = @route.list[point - 1]
	end

	private
	def self.save_trains(train)
		@@trains << train
	end
end