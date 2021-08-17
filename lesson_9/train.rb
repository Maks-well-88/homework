# frozen_string_literal: true

require_relative 'module_manufacturer'
require_relative 'instance_counter'
require_relative 'module_accessors'
require_relative 'module_validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Accessors

  NUMBER_FORMAT = /^(\d|[a-z]){3}-?(\d|[a-z]){2}$/i.freeze

  attr_accessor :speed, :wagons, :current_point, :next_station, :previous_station
  attr_reader :number, :type

  def self.save_trains
    @trains ||= []
    @trains << self
  end

  def self.all
    @trains
  end

  def self.find(number)
    @trains.find { |train| puts train if train.number == number }
  end

  def initialize(type, number = 'fsk-79')
    @number = number
    @type = type.to_sym
    @wagons = []
    @speed = 0
    validate!
    self.class.save_trains
    count_copies
  end

  def add_wagons_to_block(block)
    wagons.each_with_index { |wagon, index| block.call(wagon, index) }
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def take_route(route)
    @route = route
    self.current_point = route.list.first
  end

  def move_fwd
    point = @route.list.index(current_point)
    point += 1
    self.current_point = @route.list[point]
    self.next_station = @route.list[point + 1]
  end

  def move_back
    point = @route.list.index(current_point)
    point -= 1
    self.current_point = @route.list[point]
    self.previous_station = @route.list[point - 1]
  end

  def validate!
    errors = []
    errors << 'Неверный формат номера поезда.' if number !~ NUMBER_FORMAT
    errors << 'Неверный тип поезда.' if type != :passenger && type != :cargo
    raise errors.join(' ') unless errors.empty?
  end
end
