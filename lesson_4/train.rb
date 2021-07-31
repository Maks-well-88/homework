class Train
	attr_accessor :speed, :wagons, :current_point, :next_station, :previous_station
	attr_reader :id, :type

	def initialize(id, type)
		@id = id
		@type = type
		@wagons = []
		@speed = 0
	end

	def stop_train
		self.speed  = 0
	end

	def take_route(route)
		@route = route
		self.current_point = route.list.first
	end

	def add_wagon(wagon)
		wagons << wagon
	end
	
	def delete_wagon(wagon)
		wagons.delete(wagon)
	end

	def move_fwd
		point = @route.list.index(current_point)
		point += 1
		self.current_point = @route.list[point]
		self.next_station = @route.list[point + 1]
	end

	def move_back
		point = @route.list.index(current_point)
		point -= 1
		self.current_point = @route.list[point]
		self.previous_station = @route.list[point - 1]
	end
end