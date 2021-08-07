require_relative 'module_manufacturer.rb'

class Wagon
	include Manufacturer

	attr_reader :type
	attr_accessor :takes, :volume

	def initialize(type, volume)
		@type = type.to_sym
		@volume = volume
		@takes = 0
		validate!
	end

	def take_volume(take=1)
		@takes += take		
		@volume -= take if @volume >= 0
	end

	def valid?
		validate!
		true
	rescue
		false
	end

	def validate!
		errors = []
		errors << 'Неправильный тип вагона.' if type != :cargo && type != :passenger
		errors << 'Вместимость не может быть отрицательной или нулевой.' if self.volume <= 0
		raise errors.join(' ') unless errors.empty?
	end
end