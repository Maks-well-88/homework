require_relative 'instance_counter'

class Station
	include InstanceCounter

	attr_accessor :trains_list
	attr_reader :name

	@@all_stations = []
	
	def self.all
		puts "\nСозданы следующие станции:"
		@@all_stations.each { |station| puts " - Станция '#{station.name}'."}
		puts "\n"
	end

	def initialize(name)
		@name = name
		@trains_list = []
		self.class.save_stations(self)
		count_copies
	end

	def train_arrival(train)
		trains_list << train
	end

	def departure(train)
		trains_list.delete(train)
	end

	def train_list(station)
		puts "На станции #{station.name} находятся:"
		trains_list.each { |train| puts "- Поезд № #{train.id}, тип: #{train.type}, количество вагонов: #{train.wagons.size}."}
	end

	def train_type_list(station)
		passenger, cargo = 0, 0
		trains_list.each { |train| train.type == :passenger ? passenger += 1 : cargo += 1}
		puts "На станции #{station.name} находится #{passenger} пассажирских поездов, #{cargo} грузовых поездов."
	end

	private
	def self.save_stations(station)
		@@all_stations << station
	end
end