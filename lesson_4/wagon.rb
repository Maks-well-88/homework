class Wagon
	public # публичный метод, так как используется за пределами класса
	attr_reader :type_wagon

	def initialize(type_wagon)
		@type_wagon = type_wagon
	end
end