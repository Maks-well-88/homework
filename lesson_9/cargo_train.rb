# frozen_string_literal: true

class CargoTrain < Train
  include Manufacturer

  TYPE = :cargo

  def initialize(number)
    super(TYPE, number)
  end
end
