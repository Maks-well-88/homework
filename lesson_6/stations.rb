require_relative 'instance_counter'

class Station
	include InstanceCounter

	STATION_FORMAT = /^([а-я]|[a-z])+\s?([а-я]|[a-z])+$/i

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
		validate!
	end

	def valid?
		validate!
		true
	rescue
		false
	end

	private
	def validate!
		raise 'Отсутствует название станции!' if name.empty?
		raise if name.is_a? Integer
		raise 'Короткое название станции!' if name.length < 5
		raise 'Название станции не соответствует формату!' if name !~ STATION_FORMAT
	end

	def self.save_stations(station)
		@@stations << station
	end
end