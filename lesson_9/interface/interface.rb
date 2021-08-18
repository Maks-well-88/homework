# frozen_string_literal: true

require_relative '../stations/stations.rb'
require_relative '../trains/train.rb'
require_relative '../routes/route.rb'
require_relative '../trains/passenger_train.rb'
require_relative '../trains/cargo_train.rb'
require_relative '../wagons/wagon.rb'
require_relative '../wagons/cargo_wagon.rb'
require_relative '../wagons/passenger_wagon.rb'
require_relative '../modules/instance_counter.rb'
require_relative '../modules/manage_routes.rb'
require_relative '../modules/manage_stations.rb'
require_relative '../modules/manage_trains.rb'
require_relative '../modules/manage_wagons.rb'
require_relative '../modules/accessors.rb'
require_relative '../modules/validation.rb'

class Menu
  include ManageStations
  include ManageTrains
  include ManageRoutes
  include ManageWagons
  include Validation
  include Accessors

  attr_accessor :stations, :trains, :routes

  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def show_menu
    menu = [
      { action_block: "\nУПРАВЛЕНИЕ СТАНЦИЯМИ" },
      { action_title: 'Создать новую ж/д станцию', index: 1, action: :create_station },
      { action_title: 'Принять поезд на ж/д станцию', index: 2, action: :take_a_train },
      { action_title: 'Отправить поезд с ж/д станции', index: 3, action: :departure_train },
      { action_title: 'Вывести список поездов на станции', index: 4, action: :show_all_trains },
      { action_title: 'Показать типы поездов на всех станциях', index: 5, action: :show_type_trains },
      { break_block: "\n" },
      { action_block: 'УПРАВЛЕНИЕ ПОЕЗДАМИ' },
      { action_title: 'Создать новый поезд', index: 6, action: :create_train },
      { action_title: 'Добавить маршрут к поезду', index: 7, action: :assign_route_to_train },
      { action_title: 'Задать скорость поезду', index: 8, action: :train_change_speed },
      { action_title: 'Перемещать поезд вперед', index: 9, action: :move_forward },
      { action_title: 'Перемещать поезд назад', index: 10, action: :move_backward },
      { action_title: 'Остановить поезд', index: 11, action: :train_stop },
      { action_title: 'Показать информацию о поездах', index: 12, action: :show_accessible_trains },
      { break_block: "\n" },
      { action_block: 'УПРАВЛЕНИЕ ВАГОНАМИ' },
      { action_title: 'Присоединить вагон', index: 13, action: :hook_wagon },
      { action_title: 'Отсоединить вагон', index: 14, action: :unhook_wagon },
      { action_title: 'Заполнить вагон поезда', index: 15, action: :fill_the_carriage },
      { action_title: 'Показать список вагонов у поезда', index: 16, action: :show_wagons },
      { break_block: "\n" },
      { action_block: 'УПРАВЛЕНИЕ МАРШРУТАМИ' },
      { action_title: 'Создать новый маршрут', index: 17, action: :create_new_route },
      { action_title: 'Добавить станцию к маршруту', index: 18, action: :add_new_station },
      { action_title: 'Удалить станцию из маршрута', index: 19, action: :delete_station },
      { action_title: 'Показать список станций на маршруте', index: 20, action: :show_route_stations },
      { break_block: "\n" },
      { action_title: 'ВЫЙТИ ИЗ МЕНЮ', index: 0 }
    ]

    loop do
      menu.each do |i|
        if i[:action_block]
          puts i[:action_block]
        elsif i[:break_block]
          puts i[:break_block]
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
        break unless command != 0
      end
    end
    system 'clear'
  end

  private

  def create_train
    puts 'Создать пассажирский - (0), создать грузовой - (1).'
    print 'Введите: '
    option = gets.chomp.to_i
    types = { 0 => :create_passenger, 1 => :create_cargo }
    send(types[option].to_sym)
  end

  def show_accessible_stations
    stations.each_with_index do |station, index|
      puts "- cтанция #{station.name}, индекс - #{index}."
    end
  end

  def show_accessible_trains
    trains.each_with_index do |train, index|
      puts "- поезд № #{train.number}, тип #{train.type}, индекс - #{index}."
    end
  end

  def show_selected_stations
    stations.each.select { |station| station.trains.size >= 1 }
  end

  def show_accessible_routes
    routes.each_with_index do |route, index|
      puts "Маршрут '#{route.first_station.name}-#{route.end_station.name}', индекс: #{index}."
    end
  end
end
