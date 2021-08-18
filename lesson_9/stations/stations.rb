# frozen_string_literal: true

require_relative '../modules/instance_counter.rb'
require_relative '../modules/manage_stations.rb'
require_relative '../modules/accessors.rb'
require_relative '../modules/validation.rb'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  STATION_FORMAT = /^([а-я]|[a-z])+\s?([а-я]|[a-z])+$/i.freeze

  attr_accessor :trains
  attr_reader :name
  validate :name, :presence
  validate :name, :format, STATION_FORMAT

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
end
