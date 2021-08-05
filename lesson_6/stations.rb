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
		validate!
		self.class.save_stations(self)
		count_copies
	end

	def valid?
		validate!
		true
	rescue
		false
	end

	def validate!
		errors = []
		errors << 'Отсутствует название станции.' if name.empty?
		errors << 'Короткое название станции.' if name.length < 5
		errors << 'Название станции не соответствует формату.' if name !~ STATION_FORMAT
		raise errors.join(' ') unless errors.empty?
	end

	private
	def self.save_stations(station)
		@@stations << station
	end
end