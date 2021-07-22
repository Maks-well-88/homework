require "date"

print "Введите число: "
day = gets.chomp.to_i
print "Введите месяц: "
month = gets.chomp.to_i
print "Введите год: "
year = gets.chomp.to_i

# первое решение
last_year = year - 1
how_days = (Date.new(year,month,day) - Date.new(last_year,12,31)).to_i
puts "С начала #{year} года прошло #{how_days} дней."

# второе решение
full_year = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
full_year[1] = 29 if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 
sum_days = 0
(0...month-1).each do |i|
	sum_days += full_year[i]
end
sum_days += day 
puts "С начала #{year} года прошло #{sum_days} дней."