# frozen_string_literal: true

module ManageRoutes
  def create_new_route
    show_accessible_stations
    print 'Введите индекс начальной станции: '
    first = gets.chomp.to_i
    print 'Введите индекс конечной станции: '
    last = gets.chomp.to_i
    routes.push(Route.new(stations[first], stations[last]))
    puts "Маршрут #{stations[first].name}-#{stations[last].name} создан!"
  rescue StandardError => e
    puts e.message.to_s
  end

  def add_new_station
    show_accessible_routes
    print 'Выберите маршрут: '
    route = gets.chomp.to_i
    show_accessible_stations
    print 'Введите станцию: '
    station = gets.chomp.to_i
    routes[route].add_station(stations[station])
    puts 'Станция успешно добавлена в маршрут!'
  end

  def delete_station
    show_accessible_routes
    print 'Выберите маршрут: '
    route = gets.chomp.to_i
    routes[route].list.each_with_index { |station, index| puts "#{station.name} - #{index}." }
    print 'Выберите станцию для удаления: '
    routes[route].delete_station(routes[route].list[gets.chomp.to_i])
    puts 'Станция успешно удалена из маршрута!'
  rescue StandardError => e
    puts e.message.to_s
  end

  def show_route_stations
    show_accessible_routes
    print 'Выберите маршрут: '
    route = gets.chomp.to_i
    routes[route].show_list
  end
end
