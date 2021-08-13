# frozen_string_literal: true

module ManageTrains
  def create_train
    puts 'Создать пассажирский - (0), создать грузовой - (1).'
    print 'Введите: '
    option = gets.chomp.to_i
    types = { 0 => :create_passenger, 1 => :create_cargo }
    send(types[option])
  end

  def create_passenger
    print 'Введите номер: '
    train = PassengerTrain.new(gets.chomp)
    trains << train
    print 'Укажите производителя: '
    company = gets.chomp
    train.manufacturer = company
    puts "Поезд № #{train.number} создан производителем '#{train.manufacturer}'!"
  rescue StandardError => e
    puts e.message.to_s
  end

  def create_cargo
    print 'Введите номер: '
    train = CargoTrain.new(gets.chomp)
    trains << train
    print 'Укажите производителя: '
    company = gets.chomp
    train.manufacturer = company
    puts "Поезд № #{train.number} создан производителем '#{train.manufacturer}'!"
  rescue StandardError => e
    puts e.message.to_s
  end

  def train_change_speed
    show_accessible_trains
    print 'Введите индекс: '
    train = gets.chomp.to_i
    print 'Укажите скорость: '
    speed = gets.chomp.to_i
    trains[train].speed = speed
    puts "Поезд разогнался до #{trains[train].speed} км/ч!"
  end

  def train_stop
    show_accessible_trains
    print 'Введите индекс: '
    train = gets.chomp.to_i
    trains[train].speed = 0
    puts 'Поезд остановился!'
  end

  def assign_route_to_train
    show_accessible_trains
    print 'Введите индекс: '
    train = gets.chomp.to_i
    show_accessible_routes
    print 'Введите индекс маршрута: '
    route = gets.chomp.to_i
    trains[train].take_route(routes[route])
    puts 'Маршрут успешно добавлен поезду!'
  end

  def move_forward
    show_accessible_trains
    print 'Введите индекс: '
    train = gets.chomp.to_i
    if trains[train].current_point != routes[train].list.last
      trains[train].move_fwd
      puts "Поезд прибыл на станцию #{trains[train].current_point.name}."
      if trains[train].current_point != routes[train].list.last
        puts "Следующая станция #{trains[train].next_station.name}."
      end
    else
      puts 'Поезд на конечной, дальше не идет!'
    end
  end

  def move_backward
    show_accessible_trains
    print 'Введите индекс: '
    train = gets.chomp.to_i
    if trains[train].current_point != routes[train].list.first
      trains[train].move_back
      puts "Поезд прибыл на станцию #{trains[train].current_point.name}."
      if trains[train].current_point != routes[train].list.first
        puts "Следующая станция #{trains[train].previous_station.name}."
      end
    else
      puts 'Поезд на конечной, дальше не идет!'
    end
  end

  def trains_info
    puts 'Информация о всех поездах:'
    show_accessible_trains
  end
end
