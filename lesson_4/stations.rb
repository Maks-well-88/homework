class Station
	attr_accessor :trains_list
	attr_reader :name

	def initialize(name)
		@name = name
		@trains_list = []
	end

	def train_arrival(train)
		self.trains_list << train
	end

	def departure(train)
		self.trains_list.delete(train)
	end

	def train_list(station)
		puts "На станции #{station.name} находятся:"
		self.trains_list.each { |train| puts "- Поезд № #{train.id}, тип: #{train.type}, количество вагонов: #{train.wagons}."}
	end

	def train_type_list
		passenger, cargo = 0, 0
		self.trains_list.each { |train| train.type == 'passenger' ? passenger += 1 : cargo += 1}
		puts "На станции #{self.name} находится #{passenger} пассажирских поездов, #{cargo} грузовых поездов."
	end
end