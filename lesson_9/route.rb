# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'module_accessors'
require_relative 'module_validation'

class Route
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor :list, :first_station, :end_station

  def self.save_routes
    @routes ||= []
    @routes << self
  end

  def self.all
    @routes
  end

  def initialize(first_station, end_station)
    @first_station = first_station
    @end_station = end_station
    @list = [first_station, end_station]
    validate!
    self.class.save_routes
    count_copies
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    list[-1] = station
    list << end_station
  end

  def delete_station(station)
    raise 'Отказано в удалении!' if station == list[0] || station == list[-1]

    list.delete(station) if list[0] != station && list[-1] != station
  end

  def show_list
    list.each { |i| puts i.name }
  end

  def validate!
    errors = []
    errors << 'Отсутствует начальная точка! Попробуйте еще раз.' if first_station.nil?
    errors << 'Отсутствует конечная точка! Попробуйте еще раз.' if end_station.nil?
    raise errors.join(' ') unless errors.empty?
  end
end
