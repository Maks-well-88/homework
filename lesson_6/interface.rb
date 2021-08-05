require_relative 'module_manufacturer'

class Interface
	attr_accessor :stations, :trains, :routes

	def initialize
		@stations = []
		@trains = []
		@routes = []
	end

	def menu
		menu = [
			{action_block: "\n* УПРАВЛЕНИЯ СТАНЦИЯМИ *"},
			{action_title: "Создать новую ж/д станцию", index: 1, action: :create_station},
			{action_title: "Принять поезд на ж/д станцию", index: 2, action: :add_train_to_station},
			{action_title: "Отправить поезд с ж/д станции", index: 3, action: :departure_train_from_station},
			{action_title: "Показать все поезда на всех станциях", index: 4, action: :train_list_on_the_stations},
			{action_title: "Показать типы поездов на всех станциях", index: 5, action: :train_type_list_on_the_stations},
			{action_block: "* УПРАВЛЕНИЕ ПОЕЗДАМИ *"},
			{action_title: "Создать новый поезд", index: 6, action: :create_train},						
			{action_title: "Управлять вагонами поезда", index: 7, action: :train_carriage_manage},
			{action_title: "Задать скорость поезду", index: 8, action: :train_change_speed},
			{action_title: "Остановить поезд", index: 9, action: :train_stop},
			{action_title: "Добавить маршрут к поезду", index: 10, action: :assign_route_to_train},
			{action_title: "Перемещать поезд между станциями", index: 11, action: :drive_the_train_betwin_stations},
			{action_title: "Показать информауию о всех поездах", index: 12, action: :trains_info},
			{action_block: "* УПРАВЛЕНИЕ МАРШРУТАМИ *"},			
			{action_title: "Создать новый маршрут", index: 13, action: :create_new_route},
			{action_title: "Редактировать маршрут", index: 14, action: :change_intermediate_stations_fron_route},
			{action_title: "Показать список станций на маршруте", index: 15, action: :show_route_stations},	
			{action_title: "ВЫЙТИ ИЗ МЕНЮ", index: 0}	
		]
		
		loop do
			menu.each do |i|
				if i[:action_block]
					puts i[:action_block]			
				else
					puts "#{i[:action_title]} - (#{i[:index]})"
				end
			end
			print "\nВведите номер команды: "
			command = gets.chomp.to_i
			if command != 0
				action = menu.detect { |i| i[:index] == command }
				send(action[:action])
			else
				break
			end
		end
		system 'clear'
	end

	# === УПРАВЛЕНИЕ СТАНЦИЯМИ ===

	def create_station
		system 'clear'
		loop do
			print "Введите название станции: "
			station = Station.new(gets.chomp)
			stations << station
			system 'clear'
			puts "Станция '#{station.name}' успешно создана!"
			sleep 2
			break if station
		rescue Exception => e
			system 'clear'
			puts "#{e.message}\n"
		end
		system 'clear'
	end
	
	def add_train_to_station
		loop do
			system 'clear'
			show_accessible_stations
			print stations.empty? ? "Доступных станций нет. Введите '999', чтобы выйти: " : "\nВведите индекс станции или '999', чтобы выйти : "
			arrival_station_index = gets.chomp.to_i
			system 'clear'
			break if arrival_station_index == 999
			show_accessible_trains
			print trains.empty? ? "Доступных поездов нет. Введите '999', чтобы выйти: " : "\nВведите индекс поезда: "
			arrival_train_index = gets.chomp.to_i
			system 'clear'
			break if arrival_train_index == 999
			stations[arrival_station_index].trains.push(trains[arrival_train_index])
			system 'clear'
			puts "Поезд № #{trains[arrival_train_index].number} прибыл на станцию #{stations[arrival_station_index].name}!\n\n"
			sleep 2
			system 'clear'
		end
	end

	def departure_train_from_station
		loop do
			system 'clear'
			show_accessible_stations
			print stations.empty? ? "Доступных станций нет. Введите '999', чтобы выйти: " : "\nВведите индекс станции: "
			departure_station_index = gets.chomp.to_i
			system 'clear'
			break if departure_station_index == 999
			stations[departure_station_index].trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, индекс - #{index}."}
			print "\nВведите индекс выбранного поезда: "
			departure_train_index = gets.chomp.to_i
			system 'clear'
			puts "Поезд убыл со станции." if stations[departure_station_index].trains.delete(stations[departure_station_index].trains[departure_train_index])
			print "\nПродолжить отправлять поезда ('yes' / 'no')? "
			next_step = gets.chomp
			system 'clear'
			break if next_step == 'no'
			system 'clear'
		end
	end

	def train_list_on_the_stations
		system 'clear'
		result = stations.each.select { |station| station.trains.size >= 1 }
		result.each do |station|
			puts "На станции #{station.name} находятся:"
			station.trains.each { |train| puts" - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}."}
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
			rescue Exception => e
			system 'clear'
			puts "#{e.message} Задайте корректное значение.\n\n"
		end
		system 'clear'
	end
	
	def train_change_speed
		system 'clear'
		puts "Выберите из списка поезд, который будет разгоняться:\n\n"
		show_accessible_trains
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		system 'clear'
		print "\nУкажите скорость, до которой нужно разогнаться? "
		train_speed = gets.chomp.to_i
		trains[train_index].speed = train_speed
		system 'clear'
		puts "Поезд № #{trains[train_index].number} разогнался до скорости #{trains[train_index].speed} км/ч!"
		sleep 3
		system 'clear'
	end

	def train_stop
		system 'clear'
		puts "Выберите из списка поезда, который будет тормозить:\n\n"
		show_accessible_trains
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		trains[train_index].speed = 0
		system 'clear'
		puts "Поезд № #{trains[train_index].number} остановился!"
		sleep 3
		system 'clear'
	end
	
	def assign_route_to_train
		system 'clear'
		puts "Выберите из списка поезд, которому необходимо назначить маршрут:\n\n"
		show_accessible_trains
		print "\nВведите индекс поезда: "
		train_index = gets.chomp.to_i
		system 'clear'
		puts "Выберите маршрут из доступных:\n\n"
		show_accessible_routes
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
			show_accessible_trains
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
		rescue Exception => e
		system 'clear'
		puts "#{e.message}\n\n"
		end
		system 'clear'		
	end

	def drive_the_train_betwin_stations
		system 'clear'
		puts "Выберите поезд с назначенным маршрутом:\n\n"
		show_accessible_trains
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
		show_accessible_trains
		puts "\n"
	end

	# === УПРАВЛЕНИЕ МАРШРУТАМИ ===

	def create_new_route
		loop do
			system 'clear'
			create_route
			print "\nПродолжить создание маршрутов ('yes' / 'no')? "
			next_step = gets.chomp
			system 'clear'
			break if next_step == 'no'
		end
	end

	def change_intermediate_stations_fron_route
		system 'clear'
		loop do
			puts "Вы перешли в режим редактирования станций маршрута. Выберите маршрут из доступных:\n\n"
			show_accessible_routes
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
		show_accessible_routes
		print "\nВведите индекс маршрута: "
		route_index = gets.chomp.to_i
		system 'clear'
		puts "Список станций на маршруте #{routes[route_index].first_station.name}-#{routes[route_index].end_station.name}:\n\n"
		routes[route_index].route_list
		sleep 5
		system 'clear'
	end

	private
	def show_accessible_stations
		stations.each_with_index { |station, index| puts " - cтанция #{station.name}, индекс - #{index}."}
	end

	def show_accessible_trains
		trains.each_with_index { |train, index| puts " - поезд № #{train.number}, тип #{train.type}, количество вагонов #{train.wagons.size}, индекс - #{index}."}
	end

	def show_accessible_routes
		routes.each_with_index { |route, index| puts "Маршрут '#{route.first_station.name}-#{route.end_station.name}': индекс - #{index}."}
	end

	def hook_wagon
		if trains[@carriage_train].type == :cargo && trains[@carriage_train].speed == 0
			loop do
				print "Укажите производителя вагона: "
				company = gets.chomp
				puts 'Укажите корректное навзание производителя' if company != /^.{3}+$/i
				break if company == /^.{3}+$/i
			end
			cargo_wagon = CargoWagon.new
			trains[@carriage_train].wagons.push(cargo_wagon)
			cargo_wagon.manufacturer = company
			system 'clear'
			puts "Вагон от производителя '#{cargo_wagon.manufacturer}' успешно присоединен!"
			sleep 3
			system 'clear'
		elsif trains[@carriage_train].type == :passenger && trains[@carriage_train].speed == 0
			print "Укажите производителя вагона: "
			company = gets.chomp		
			passenger_wagon = PassengerWagon.new
			trains[@carriage_train].wagons.push(passenger_wagon)
			passenger_wagon.manufacturer = company
			system 'clear'
			puts "Вагон от производителя '#{passenger_wagon.manufacturer}' успешно присоединен!"
			sleep 3
			system 'clear'
		end
	end

	def unhook_wagon
		trains[@carriage_train].wagons.delete(trains[@carriage_train].wagons[0])
		puts "Вагон успешно отсоединен!"
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
			puts "\nПоезд прибыл на конечную станцию и дальше не идет!\n\n"
		end
	end

	def add_new_station_on_the_route
		system 'clear'
		puts "Выберите из списка станцию, которую необходимо добавить в маршрут:\n\n"
		show_accessible_stations
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
		show_accessible_stations
		print "\nВведите индекс станции для первой точки маршрута: "
		first_index = gets.chomp.to_i
		print "Введите индекс станции для второй точки маршрута: "
		last_index = gets.chomp.to_i
		system 'clear'
		routes.push(Route.new(stations[first_index], stations[last_index]))
		puts "Маршрут #{stations[first_index].name}-#{stations[last_index].name} успешно создан!"
		rescue Exception => e		
		puts "#{e.message}\n\n"
	end

	def create_passenger_train
		print 'Введите номер поезда: '
		number = gets.chomp
		train = PassengerTrain.new(number)
		trains << train
		train.manufacturer = company
		system 'clear'
		puts "Новый поезд № #{train.number} успешно создан производителем '#{train.manufacturer}'!" 
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
		puts "Новый поезд № #{train.number} успешно создан производителем '#{train.manufacturer}'!"
		sleep 3
		system 'clear'
	end
end
