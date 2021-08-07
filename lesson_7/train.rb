require_relative 'module_manufacturer'
require_relative 'instance_counter'

class Train
	include Manufacturer
	include InstanceCounter

	NUMBER_FORMAT = /^(\d|[a-z]){3}-?(\d|[a-z]){2}$/i

	attr_accessor :speed, :wagons, :current_point, :next_station, :previous_station
	attr_reader :number, :type

	@@trains = []

	def self.find(number)
		@@trains.find { |train| puts train if train.number == number }
	end

	def initialize(number = 'fsk-79', type)
		@number = number
		@type = type.to_sym
		@wagons = []
		@speed = 0
		validate!
		self.class.save_trains(self)
		count_copies
	end

	def add_wagons_to_block(block)
		self.wagons.each_with_index { |wagon, index| block.call(wagon, index)}
	end

	def valid?
		validate!
		true
	rescue
		false
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

	def validate!
		errors = []
		errors << 'Неверный формат номера поезда.' if number !~ NUMBER_FORMAT
		errors << 'Неверный тип поезда.' if type != :passenger && type != :cargo
		raise errors.join(' ') unless errors.empty?
	end

	protected
	def self.save_trains(train)
		@@trains << train
	end
end