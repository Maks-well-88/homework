# frozen_string_literal: true

require_relative '../modules/manufacturer.rb'

class Wagon
  include Manufacturer

  attr_reader :type, :place, :taken_place

  def initialize(type, place)
    @type = type.to_sym
    @place = place
    @taken_place = 0
    validate!
  end

  def free_place
    place - taken_place
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def validate!
    errors = []
    errors << 'Неправильный тип вагона.' if type != :cargo && type != :passenger
    errors << 'Вместимость не может быть отрицательной или нулевой.' if place <= 0
    raise errors.join(' ') unless errors.empty?
  end
end
