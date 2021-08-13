# frozen_string_literal: true

module ManageStations
  attr_accessor :station

  def create_station
    print 'Введите название станции: '
    station = Station.new(gets.chomp)
    stations << station
    puts "Станция '#{station.name}' успешно создана!"
  rescue StandardError => e
    puts "#{e.message}\n"
  end

  def take_a_train
    loop do
      show_accessible_stations
      print stations.empty? ? "Нет станций. Введите '999', чтобы выйти: " : 'Введите индекс: '
      station = gets.chomp.to_i
      break if station == 999

      show_accessible_trains
      print 'Введите индекс поезда: '
      train = gets.chomp.to_i
      stations[station].trains.push(trains[train])
      puts 'Поезд прибыл на станцию.'
      break
    end
  end

  def departure_train
    loop do
      result = show_selected_stations
      result.each_with_index { |station, index| puts "- cтанция #{station.name}, индекс - #{index}." }
      print result.empty? ? "Нет станций. Введите '999', чтобы выйти: " : 'Введите индекс: '
      station = gets.chomp.to_i
      break if station == 999

      result[station].trains.each_with_index do |train, index|
        puts "- поезд №#{train.number}, индекс: #{index}."
      end
      print 'Введите индекс поезда: '
      train = gets.chomp.to_i
      result[station].trains.delete(result[station].trains[train])
      puts 'Поезд убыл со станции.'
      break
    end
  end

  def show_all_trains
    show_accessible_stations
    print 'Выберите станцию: '
    choise = gets.chomp.to_i
    block = ->(train) { puts "Поезд № #{train.number}, тип: #{train.type}, вагонов: #{train.wagons.size}." }
    stations[choise].add_stations_to_block(block)
  end

  def show_type_trains
    result = show_selected_stations
    result.each do |station|
      puts "На станции #{station.name} находятся:"
      cargo = 0
      passenger = 0
      station.trains.each { |train| train.type == :cargo ? cargo += 1 : passenger += 1 }
      puts "Грузовых поездов: #{cargo}, пассажирских поездов: #{passenger}.\n\n"
    end
  end
end
