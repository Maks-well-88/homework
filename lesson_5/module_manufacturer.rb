module Manufacturer
	# доступ публичный, так как используется в интерфейсе
	# производитель поезда указывается при его создании, наименование производителя выводится по факту создания поезда
	# производитель вагона также указывается при его создании, наименование производителя выводится по факту создания вагона и его присоединения
	attr_accessor :company
	
	def manufacturer(company)
		self.company = company
	end
end