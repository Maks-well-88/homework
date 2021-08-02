require_relative 'instance_counter'

class Station
	include InstanceCounter

	attr_accessor :trains
	attr_reader :name

	@@stations = []
	
	def self.all
		@@stations
	end

	def initialize(name)
		@name = name
		@trains = []
		self.class.save_stations(self)
		count_copies
	end

	private
	def self.save_stations(station)
		@@stations << station
	end
end