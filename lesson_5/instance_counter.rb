module InstanceCounter
	# инициализатор для модуля, когда класс включает модуль
	def self.included(base)
		base.include InstanceMethods
		base.extend ClassMethods
	end

	module ClassMethods
		# инициализатор для модуля, когда класс расширяет модуль
		def self.extended(base)
			class << base; attr_accessor :number_of_copies end
		end

		# возвращает кол-во экземпляров данного класса
		def instances
			@number_of_copies
		end
	end

	module InstanceMethods
		def count_copies
			register_instance
		end
		
		private
		# данный метод приватный, увеличивает счетчик кол-ва экземпляров класса
		# self.class позволяет нам возвращать подкласс и считать его счетчик в отдельности
		# вызывается из конструктора с помощью count_copies
		def register_instance 
			self.class.number_of_copies ||= 0
			self.class.number_of_copies += 1
		end
	end
end