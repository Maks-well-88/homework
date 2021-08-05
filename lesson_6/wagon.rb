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

	def validate!
		errors = []
		errors << 'Неправильный тип вагона.' if type != :cargo && type != :passenger		
		raise errors.join(' ') unless errors.empty?
	end
end