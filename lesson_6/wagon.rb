require_relative 'module_manufacturer.rb'

class Wagon
	include Manufacturer

	attr_reader :type

	def initialize(type)
		@type = type.to_sym
		validate!
	end

	def valid?
		validate!
		true
	rescue
		false
	end

	protected
	def validate!
		raise 'Неправильный тип вагона!' if type != :cargo && type != :passenger
	end
end