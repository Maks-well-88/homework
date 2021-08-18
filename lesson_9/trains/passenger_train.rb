# frozen_string_literal: true

class PassengerTrain < Train
  TRAIN_TYPE = :passenger

  def initialize(number)
    super(TRAIN_TYPE, number)
  end
end
