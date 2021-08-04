require_relative 'instance_counter'

class Route
	include InstanceCounter

	attr_accessor :list, :first_station, :end_station
	
	def initialize(first_station, end_station)
		@first_station = first_station
		@end_station = end_station
		@list = [first_station, end_station]
		count_copies
		validate!
	end

	def valid?
		validate!
		true
	rescue
		false
	end

	def add_station_route(station)
		list[-1] = station
		list << end_station
	end

	def delete_station_route(station)
		list.delete(station) if list.first.name != station.name && list.last.name != station.name
	end

	def route_list
		list.each {|i| puts i }
	end

	private
	def validate!
		raise 'Не корректно построен маршрут! Попробуйте еще раз!' if first_station.nil? || end_station.nil?
	end
end