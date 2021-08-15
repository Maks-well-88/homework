# frozen_string_literal: true

module ManageWagons
  def fill_the_carriage
    show_accessible_trains
    print 'Выберите поезд: '
    train = gets.chomp.to_i
    trains[train].wagons.each_with_index { |wagon, index| puts "Вагон #{wagon.type} - (#{index})" }
    print 'Укажите индекс вагона: '
    wagon = gets.chomp.to_i
    print 'Укажите сколько занять места в вагоне: '
    trains[train].wagons[wagon].take_place(gets.chomp.to_i)
    puts 'Место успешно заполнено!'
  rescue StandardError => e
    puts e.message.to_s
  end

  def show_wagons
    show_accessible_trains
    print 'Выберите поезд: '
    choise = gets.chomp.to_i
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
    actions = { cargo: CargoWagon, passenger: PassengerWagon }
    print 'Укажите вместимость вагона: '
    wagon = actions[trains[train].type].new(gets.chomp.to_i) if trains[train].speed.zero?
    trains[train].wagons.push(wagon)
    print 'Укажите производителя вагона: '
    wagon.manufacturer = gets.chomp
    puts "Вагон от производителя '#{wagon.manufacturer}' успешно присоединен!"
  end

  def unhook_wagon
    show_accessible_trains
    print 'Введите индекс поезда: '
    train = gets.chomp.to_i
    trains[train].wagons.delete(trains[train].wagons[0])
    puts 'Вагон успешно отсоединен!'
  end
end
