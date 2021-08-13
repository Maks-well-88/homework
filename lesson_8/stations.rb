# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'module_manage_stations'

class Station
  include InstanceCounter

  STATION_FORMAT = /^([а-я]|[a-z])+\s?([а-я]|[a-z])+$/i.freeze

  attr_accessor :trains
  attr_reader :name

  def self.save_stations
    @stations ||= []
    @stations << self
  end

  def self.all
    @stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.save_stations
    count_copies
  end

  def add_stations_to_block(block)
    trains.each { |train| block.call(train) }
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def validate!
    errors = []
    errors << 'Отсутствует название станции.' if name.empty?
    errors << 'Короткое название станции.' if name.length < 5
    errors << 'Название станции не соответствует формату.' if name !~ STATION_FORMAT
    raise errors.join(' ') unless errors.empty?
  end
end
