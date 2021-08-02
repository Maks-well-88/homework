require_relative 'module_manufacturer'

class Interface
	attr_accessor :stations, :trains, :routes

	def initialize
		@stations = []
		@trains = []
		@routes = []
	end

	def menu
		loop do
			puts "\nДля УПРАВЛЕНИЯ СТАНЦИЯМИ введите номер команды."
			puts "Создать новую ж/д станцию - (1)"
			puts "Принять поезд на ж/д станцию - (2)"
			puts "Отправить поезд с ж/д станции - (3)"
			puts "Показать все поезда на всех станциях - (4)"
			puts "Показать типы поездов на всех станциях - (5)"
			puts "\n"# ===========================================================================
			puts "Для УПРАВЛЕНИЕ ПОЕЗДАМИ введите номер команды."
			puts "Создать новый поезд - (6)"
			puts "Управлять вагонами поезда - (7)"
			puts "Задать скорость поезду - (8)"
			puts "Остановить поезд - (9)"
			puts "Добавить маршрут к поезду - (10)"
			puts "Перемещать поезд между станциями - (11)"
			puts "Показать информауию о всех поездах - (12)"
			puts "\n"# ===========================================================================
			puts "Для УПРАВЛЕНИЕ МАРШРУТАМИ введите номер команды."
			puts "Создать новый маршрут - (13)"
			puts "Редактирование маршрута - (14)"
			puts "Показать список станций на маршруте - (15)"
			puts "\n"# ===========================================================================
			puts "ВЫЙТИ ИЗ МЕНЮ - (000)"
			puts "\n"# ===========================================================================
			print "\nВведите номер команды: "
			command = gets.chomp.to_i
			case command
			when 1 then create_new_station
			when 2 then add_train_to_station
			when 3 then departure_train_from_station
			when 4 then train_list_on_the_stations
			when 5 then train_type_list_on_the_stations
			when 6 then create_train
			when 7 then train_carriage_manage
			when 8 then train_change_speed
			when 9 then train_stop
			when 10 then assign_route_to_train
			when 11 then drive_the_train_betwin_stations
			when 12 then trains_info
			when 13 then create_new_route
			when 14 then change_intermediate_stations_fron_route
			when 15 then show_route_stations
			when 000 then break
			end
		end
		system 'clear'	
	end

	# === УПРАВЛЕНИЕ СТАНЦИЯМИ ===

	def create_new_station
		system 'clear'
		loop do
			create_station
			print "\nПродолжить создание станций ('yes' / 'no')? "
			next_step = gets.chomp
			break if next_step == 'no'
			system 'clear'
		end
		system 'clear'
	end
	
	def add_train_to_station
		system 'clear'
		loop do
			puts "Выберите из списка станцию, на которую необходимо принять поезд:\n\n"
			stations.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}."}
			print "\nВведите индекс станции, а если их нет, то введите '999', чтобы выйти: "
			arrival_station_index = gets.chomp.to_i
			break if arrival_station_index == 999
			system 'clear'
			puts "Выберите из списка номер поезда, который будет приниматься на станцию:\n\n"
			trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
			print "\nВведите индекс поезда, а если его нет, то введите '999', чтобы выйти: "
			arrival_train_index = gets.chomp.to_i
			break if arrival_train_index == 999
			stations[arrival_station_index].trains.push(trains[arrival_train_index])
			system 'clear'
		  puts '/////////////////////////////////////////////////////////'
			puts "Поезд № #{trains[arrival_train_index].number} прибыл на станцию #{stations[arrival_station_index].name}!"
		  puts '/////////////////////////////////////////////////////////'
			print "\nПродолжить принимать поезда ('yes' / 'no')? "
			next_step = gets.chomp
			break if next_step == 'no'
			system 'clear'
		end
		system 'clear'
	end

	def departure_train_from_station
		loop do
			system 'clear'
			puts "Выберите из списка станцию, поезда на которой доступны для отправления:\n\n"
			stations.each_with_index.select { |station, index| puts " - cтанция #{station.name}, индекс - #{index}." if station.trains.size >= 1 }
			print "\nВведите индекс выбранной станции: "
			departure_station_index = gets.chomp.to_i 
			system 'clear'
			puts "На станции #{stations[departure_station_index].name} доступны к отправлению следующие поезда:\n\n"
			stations[departure_station_index].trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
			print "\nВведите индекс выбранного поезда: "
			departure_train_index = gets.chomp.to_i
			system 'clear'
			stations[departure_station_index].trains.delete(stations[departure_station_index].trains[departure_train_index])
		  puts '/////////////////////////////////////////////////////////'			
			puts "Выбранный поезд убыл со станции #{stations[departure_station_index].name}!"
		  puts '/////////////////////////////////////////////////////////'
			print "\nПродолжить отправлять поезда ('yes' / 'no')? "
			next_step = gets.chomp
			system 'clear'
			break if next_step == 'no'
			system 'clear'
			result = stations.each.select { |station| station.trains.size >= 1 }
			if result.size == 0
			  puts '/////////////////////////////////////////////////////////'
				puts "Нет доступных поездов к отправлению!"
			  puts "/////////////////////////////////////////////////////////\n\n"
  			sleep 3
				system 'clear'
				break
			end

		end
	end

	def train_list_on_the_stations
		system 'clear'
		result = stations.each.select { |station| station.trains.size >= 1 }
		result.each do |station|
			puts "На станции #{station.name} находятся:"
			station.trains.each { |train| puts" - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}."}
			puts "\n"
		end
		sleep 5
		system 'clear'

	end

	def train_type_list_on_the_stations
		system 'clear'
		result = stations.each.select { |station| station.trains.size >= 1 }			
		result.each do |station|
			puts "На станции #{station.name} находятся:"
			cargo, passenger = 0, 0
			station.trains.each { |train| train.type == :cargo ? cargo += 1 : passenger += 1 }
			puts "Грузовых поездов: #{cargo}, пассажирских поездов: #{passenger}.\n\n"
		end
		sleep 5
		system 'clear'
	end

	# === УПРАВЛЕНИЕ ПОЕЗДАМИ ===

	def create_train
		system 'clear'
		loop do
			puts "Введите 'passenger', чтобы создать пассажирский поезд.\n" + 
			"Введите 'cargo', чтобы создать грузовой поезд.\n" + 
			"Введите 'back', чтобы выйти из режима создания поездов."
			print "Введите: "
			option = gets.chomp
			case option
			when 'passenger' then create_passenger_train
			when 'cargo' then create_cargo_train
			when 'back' then break
			end
		end
		system 'clear'
	end
	
	def train_change_speed
		system 'clear'
		puts "Выберите из списка поезд, который будет разгоняться:\n\n"
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		system 'clear'
		print "\nУкажите скорость, до которой нужно разогнаться? "
		train_speed = gets.chomp.to_i
		trains[train_index].speed = train_speed
		system 'clear'
		puts '/////////////////////////////////////////////////////////'
		puts "Поезд № #{trains[train_index].number} разогнался до скорости #{trains[train_index].speed} км/ч!"
		puts '/////////////////////////////////////////////////////////'
		sleep 3
		system 'clear'
	end

	def train_stop
		system 'clear'
		puts "Выберите из списка поезда, который будет тормозить:\n\n"
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, скорость #{train.speed} км/ч, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}." if train.speed != 0 }
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		trains[train_index].speed = 0
		system 'clear'
		puts '/////////////////////////////////////////////////////////'		
		puts "Поезд № #{trains[train_index].number} остановился!"
		puts '/////////////////////////////////////////////////////////'
		sleep 3
		system 'clear'
	end
	
	def assign_route_to_train
		system 'clear'
		puts "Выберите из списка поезд, которому необходимо назначить маршрут:\n\n"
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		system 'clear'
		puts "Выберите маршрут из доступных:\n\n"
		routes.each_with_index { |route, index | puts "Маршрут '#{route.first_station.name}-#{route.end_station.name}': индекс - #{index}."}
		print "\nВведите индекс маршрута, который хотите назначить поезду: "
		@route_index = gets.chomp.to_i
		trains[train_index].take_route(routes[@route_index])
		system 'clear'
		puts "\nМаршрут успешно добавлен поезду!\n\n"
	end

	def train_carriage_manage
		system 'clear'
		loop do
			puts "Выберите поезд, у которого необходимо провести операцию с вагонами:\n\n"
			trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
			print "\nВведите индекс поезда или введите 999, чтобы выйти: "
			@carriage_train = gets.chomp.to_i
			system 'clear'
			break if @carriage_train == 999
			puts "Дайте команду по вагонам!"
			puts "Чтобы прицепить вагоны, введите 'hook'."
			puts "Чтобы отцепить вагоны, введите 'unhook'."
			print "\nВведите действие: "
			get_order = gets.chomp
			system 'clear'
			case get_order
			when 'hook' then hook_wagon
			when 'unhook' then unhook_wagon
			end
		end
		system 'clear'		
	end

	def drive_the_train_betwin_stations
		system 'clear'
		puts "Выберите поезд с назначенным маршрутом:\n\n"
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}.\n" if train.current_point }
		print "\nВведите индекс поезда: "
		@drive_train = gets.chomp.to_i
		system 'clear'
		puts "Веберите неправление движения."
		puts "Чтобы поехать вперед, введите 'fwd'."
		puts "Чтобы поехать назад, введите 'back'."
		print "Введите ваш вариант: "
		direction = gets.chomp
		system 'clear'
		case direction
		when 'fwd' then move_forward
		when 'back' then move_backward
		end
	end

	def trains_info
		system 'clear'
		puts "\nИнформация о всех поездах:"
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
		puts "\n"
	end

	# === УПРАВЛЕНИЕ МАРШРУТАМИ ===

	def create_new_route
		loop do
			system 'clear'
			create_route
			print "Продолжить создание маршрутов ('yes' / 'no')? "
			next_step = gets.chomp
			system 'clear'
			break if next_step == 'no'
		end		
	end

	def change_intermediate_stations_fron_route
		system 'clear'
		loop do
			puts "Вы перешли в режим редактирования станций маршрута. Выберите маршрут из доступных:\n\n"
			routes.each_with_index { |route, index | puts "Маршрут '#{route.first_station.name}-#{route.end_station.name}': индекс - #{index}."}
			print "\nВведите индекс маршрута, который хотите отредактировать или введите '999', чтобы выйти: "
			@route_index = gets.chomp.to_i
			system 'clear'
			break if @route_index == 999
			puts "Для того, чтобы добавить станции в выбранный маршрут введите 'add'."
			puts "Для того, чтобы удалить станцию из выбранного маршрута введите 'delete'."
			puts "Для того, чтобы вернуться в выбору нового маршрута введите 'route'."
			puts "Для того, чтобы выйти из режима редактирования маршрута введите 'stop'."
			print "Введите следующее действие: "
			answer = gets.chomp
			case answer
			when 'add' then add_new_station_on_the_route
			when 'delete' then delete_station_at_the_route
			when 'route' then change_intermediate_stations_fron_route
			when 'stop' then break
			else puts "\nВы ввели неправильную команду, начните сначала!\n\n"
			end
		end
		system 'clear'
	end

	def show_route_stations
		system 'clear'
		puts "Выберите маршут из доступных:\n\n"
		routes.each_with_index { |route, index | puts "Маршрут '#{route.first_station.name}-#{route.end_station.name}': индекс - #{index}."}
		print "\nВведите индекс маршрута: "
		route_index = gets.chomp.to_i
		system 'clear'
		puts "Список станций на маршруте #{@routes[route_index].first_station.name}-#{@routes[route_index].end_station.name}:\n\n"
		routes[route_index].route_list
		sleep 5
		system 'clear'
	end

	private
	def hook_wagon
		if trains[@carriage_train].type == :cargo && trains[@carriage_train].speed == 0
			print "Укажите производителя вагона: "
			company = gets.chomp
			cargo_wagon = CargoWagon.new
			trains[@carriage_train].wagons.push(cargo_wagon)
			cargo_wagon.manufacturer = company
			system 'clear'
		  puts '/////////////////////////////////////////////////////////'
			puts "Вагон от производителя '#{cargo_wagon.manufacturer}' успешно присоединен!"
			puts '/////////////////////////////////////////////////////////'
			sleep 3
			system 'clear'
		elsif trains[@carriage_train].type == :passenger && trains[@carriage_train].speed == 0
			print "Укажите производителя вагона: "
			company = gets.chomp		
			passenger_wagon = PassengerWagon.new
			trains[@carriage_train].wagons.push(passenger_wagon)
			passenger_wagon.manufacturer = company
			system 'clear'
			puts '/////////////////////////////////////////////////////////'
			puts "Вагон от производителя '#{passenger_wagon.manufacturer}' успешно присоединен!"
			puts '/////////////////////////////////////////////////////////'
			sleep 3
			system 'clear'
		end
	end

	def unhook_wagon
		trains[@carriage_train].wagons.delete(trains[@carriage_train].wagons[0])
		puts '/////////////////////////////////////////////////////////'
		puts "Вагон успешно отсоединен!"
		puts '/////////////////////////////////////////////////////////'
		sleep 3
		system 'clear'
	end

	def move_forward
		if trains[@drive_train].current_point.name != @routes[@drive_train].list.last.name
			trains[@drive_train].move_fwd
			puts "\nПоезд № #{trains[@drive_train].number} прибыл на станцию #{trains[@drive_train].current_point.name}."
			puts "Следующая станция #{trains[@drive_train].next_station.name}.\n\n" if trains[@drive_train].current_point.name != routes[@drive_train].list.last.name
		else
			puts "\nПоезд прибыл на конечную станцию и дальше не идет!\n\n"
		end
	end

	def move_backward
		if trains[@drive_train].current_point.name != routes[@drive_train].list.first.name
			trains[@drive_train].move_back
			puts "\nПоезд № #{trains[@drive_train].number} прибыл на станцию #{trains[@drive_train].current_point.name}.\n\n"
			puts "Следующая станция #{trains[@drive_train].previous_station.name}.\n\n" if trains[@drive_train].current_point.name != routes[@drive_train].list.first.name && trains[@drive_train].current_point.name != routes[@drive_train].list.last.name 
		else
			puts '/////////////////////////////////////////////////////////'
			puts "\nПоезд прибыл на конечную станцию и дальше не идет!\n\n"
			puts '/////////////////////////////////////////////////////////'
		end
	end

	def add_new_station_on_the_route
		system 'clear'
		puts "Выберите из списка станцию, которую необходимо добавить в маршрут:\n\n"
		stations.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}."}
		print "\nВведите индекс станции: "
		station_index = gets.chomp.to_i 
		routes[@route_index].add_station_route(stations[station_index])
		system 'clear'
		puts "Станция успешно добавлена в маршрут!\n\n"
		sleep 2
		system 'clear'
	end

	def delete_station_at_the_route
		system 'clear'
		routes[@route_index].list.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}." }
		print "Выберите из списка станцию, которую необходимо удалить из маршрута: "
		delete_index = gets.chomp.to_i
		routes[@route_index].delete_station_route(routes[@route_index].list[delete_index])
		system 'clear'
		if routes[@route_index].list[delete_index] == routes[@route_index].list[0] || routes[@route_index].list[delete_index] == routes[@route_index].list[-1]
			puts "\nВыбранную станции нельзя удалить! Попробуйте еще раз!\n\n"
		else
			puts "\nСтанция успешно удалена из маршрута!\n\n"
			routes[@route_index].list.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}." }
			puts "\n"
		end
	end

	def create_route
		puts "Чтобы создать маршрут выберите доступные станции:\n\n"
		stations.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}." }
		print "\nВведите индекс станции для первой точки маршрута: "
		first_index = gets.chomp.to_i
		print "Введите индекс станции для второй точки маршрута: "
		last_index = gets.chomp.to_i	
		routes.push(Route.new(stations[first_index], stations[last_index]))
		system 'clear'
		puts "Маршрут #{stations[first_index].name}-#{stations[last_index].name} успешно создан!\n\n"
	end

	def create_station
		print "Введите название станции: "
		station = gets.chomp
		station = Station.new(station)
		stations << station
		system 'clear'
		puts "Станция #{station.name} создана!"
	end

	def create_passenger_train
		print 'Введите номер поезда: '
		number = gets.chomp
		print 'Укажите производителя поезда: '
		company = gets.chomp
		train = PassengerTrain.new(number)
		trains << train
		train.manufacturer = company
		system 'clear'
		puts '/////////////////////////////////////////////////////////'
		puts "Новый поезд № #{train.number} успешно создан производителем '#{train.manufacturer}'!"
		puts '/////////////////////////////////////////////////////////'
		sleep 3
		system 'clear'
	end

	def create_cargo_train
		print 'Введите номер поезда: '
		number = gets.chomp
		print 'Укажите производителя поезда: '
		company = gets.chomp
		train = CargoTrain.new(number)
		trains << train
		train.manufacturer = company
		system 'clear'
		puts '/////////////////////////////////////////////////////////'
		puts "Новый поезд № #{train.number} успешно создан производителем '#{train.manufacturer}'!"
		puts '/////////////////////////////////////////////////////////'
		sleep 3
		system 'clear'
	end
end
