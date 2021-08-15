# frozen_string_literal: true

module ManageWagons
  def fill_the_carriage
    show_accessible_trains
    print 'Выберите поезд: '
    train = gets.chomp.to_i
    trains[train].wagons.each_with_index do |wagon, index|
      puts "Вагон, индекс #{index}, #{wagon.type}."
    end
    print 'Укажите индекс вагона: '
    wagon = gets.chomp.to_i
    print 'Укажите сколько занять места в вагоне: '
    amount = gets.chomp.to_i
    trains[train].wagons[wagon].take_place(amount)
    puts 'Место успешно заполнено!'
  rescue StandardError => e
    puts e.message.to_s
  end

  def show_trains
    show_accessible_trains
    print 'Выберите поезд: '
    choise = gets.chomp.to_i
    system 'clear'
    block = lambda do |wagon, index|
      puts "Вагон № #{index + 1}, занято #{wagon.class::UNIT}: #{wagon.taken_place}, " \
           "свободно #{wagon.class::UNIT}: #{wagon.free_place}."
    end
    trains[choise].add_wagons_to_block(block)
  end

  def hook_wagon
    show_accessible_trains
    print 'Введите индекс поезда: '
    train = gets.chomp.to_i
    if trains[train].type == :cargo && trains[train].speed.zero?
      print 'Укажите производителя вагона: '
      company = gets.chomp
      print 'Укажите вместимость вагона: '
      volume = gets.chomp.to_i
      cargo_wagon = CargoWagon.new(volume)
      trains[train].wagons.push(cargo_wagon)
      cargo_wagon.manufacturer = company
      puts "Вагон от производителя '#{cargo_wagon.manufacturer}' успешно присоединен!"
    elsif trains[train].type == :passenger && trains[train].speed.zero?
      print 'Укажите производителя вагона: '
      company = gets.chomp
      print 'Укажите вместимость вагона: '
      volume = gets.chomp.to_i
      passenger_wagon = PassengerWagon.new(volume)
      trains[train].wagons.push(passenger_wagon)
      passenger_wagon.manufacturer = company
      puts "Вагон от производителя '#{passenger_wagon.manufacturer}' успешно присоединен!"
    end
  end

  def unhook_wagon
    show_accessible_trains
    print 'Введите индекс поезда: '
    train = gets.chomp.to_i
    trains[train].wagons.delete(trains[train].wagons[0])
    puts 'Вагон успешно отсоединен!'
  end
end
