module InstanceCounter
	def self.included(base)
		base.include InstanceMethods
		base.extend ClassMethods
	end

	module ClassMethods
		def self.extended(base)
			class << base; attr_accessor :number_of_copies end
		end

		def instances
			@number_of_copies
		end
	end

	module InstanceMethods
		def count_copies
			register_instance
		end
		
		private
		def register_instance 
			self.class.number_of_copies ||= 0
			self.class.number_of_copies += 1
		end
	end
end