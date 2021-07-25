class Station
	attr_reader :name # может возвращать список всех поездов на станции и имена станций

	def initialize(name) # имеет название, указывается при создании
		@name = name
		@train_park_list = []
	end

	def arrival_train(train) # может принимать поезда по одному за раз
		train_park_list << train
	end

	def station_list
		@train_park_list.each { |i| puts "Поезд № #{i.id}, тип '#{i.type}', кол-во вагонов #{i.wagons}.\n" }
	end

	def train_types # возвращает список поездов по типу: кол-во грузовых, пассажирских
		pass, cargo = 0, 0
		@train_park_list.each { |i| i.type == 'passenger' ? pass += 1 : cargo += 1 }
		puts "На станции #{self.name}:\n - пассажирских поездов: #{pass};\n - грузовых поездов: #{cargo}."
	end

	def departure_train(train) # может отпарвлять поезда по одному за раз
		train_park_list.delete(train)
	end
end

class Route
	attr_reader :list
	
	def initialize(first_station, end_station) # начальная и конечная станции указываются при создании маршрута
		@first_station = first_station
		@end_station = end_station
		@list = [@first_station, @end_station]
	end

	def add_station_route(station) # добавляет промежуточную станцию в список
		@list[-1] = station
		@list << @end_station
	end

	def delete_station_route(station) # удаляет только промежуточную станцию из списка
		@list.delete(station) if @list.first.name != station.name && @list.last.name != station.name
	end

	def route_list # выводит список всех станций по порядку от начальной до конечной
		@list.each {|i| puts "Станция: #{i.name}." }
	end
end

class Train
	attr_reader :id, :type, :wagons # может возвращать id, тип и количество вагонов
	attr_accessor :speed # может набирать и возвращать текущую скорость

	def initialize(id, type, wagons) # номер, тип (cargo / passenger), кол-во вагонов
		@id = id 
		@type = type
		@wagons = wagons
		@speed = 0
	end

	def stop
		self.speed = 0 # может тормозить (0 км/ч)
	end

	def change_wagons # прицеплять/отцеплять вагоны, когда поезд не движется
		print "Введите 'add', чтобы добавить вагон, или 'del', чтобы отцепить его: "
		change = gets.chomp
		case change
		when 'add' then @wagons += 1 if @speed == 0
		when 'del' then @wagons -= 1 if @speed == 0
		end
	end

	def new_way(route) # может принимать маршрут следования
		@route = route
		@current = route.list[0]
		puts "Поезд № #{self.id} прибыл на станцию #{@current.name}." # поезд автоматически перемещается на 1-ю станцию
	end

	def move # может перемещаться между станциями на 1 станцию за раз
		current = @route.list.index(@current)
		print "Введите 'fwd', чтобы поехать вперед или введите 'back', чтобы поехать назад: "
		option = gets.chomp
		case option
		when 'fwd' 
			current += 1 if @route.list[current] != @route.list.last
			@current = @route.list[current]
			puts "Поезд № #{self.id} прибыл на станцию #{@current.name}."
			puts "Прошлая станция: #{@route.list[current - 1].name}." if @route.list[current - 1] != nil
			puts "Следующая станция: #{@route.list[current + 1].name}." if @route.list[current + 1] != nil
			puts "Поезд дальше не идет. Освободите вагон!" if @route.list[current - 1] == nil || @route.list[current + 1] == nil
		when 'back'
			current -= 1 if @route.list[current] != @route.list.first
			@current = @route.list[current]
			puts "Поезд № #{self.id} прибыл на станцию #{@current.name}."
			puts "Прошлая станция: #{@route.list[current + 1].name}." if @route.list[current + 1] != nil
			puts "Следующая станция: #{@route.list[current - 1].name}." if @route.list[current - 1] != @route.list.last
			puts "Поезд дальше не идет. Освободите вагон!" if @route.list[current - 1] == @route.list.last
		end
	end
end