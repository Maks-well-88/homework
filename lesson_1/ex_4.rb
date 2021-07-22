print "Введите первый коэффициент: "
a = gets.chomp.to_i
print "Введите второй коэффициент: "
b = gets.chomp.to_i
print "Введите третий коэффициент: "
c = gets.chomp.to_i
D = (b ** 2) - (4 * a * c)
C = Math.sqrt(D)
x1 = (-b + C) / (2 * a)
x2 = (-b - C) / (2 * a)
if D < 0
	puts "Дискриминант: #{D}. Корней нет."
elsif D > 0
	puts "Дискриминант: #{D}, первый корень #{x1}, второй корень #{x2}."
elsif D == 0
	puts "Дискриминант: #{D}, корень #{x1}."
end
