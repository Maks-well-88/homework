print "Укажите первую сторону треугольника в сантиметрах: "
a = gets.chomp.to_f
print "Укажите вторую сторону треугольника в сантиметрах: "
b = gets.chomp.to_f
print "Укажите третью сторону треугольника в сантиметрах: "
c = gets.chomp.to_f
a, b, c = [a, b, c].sort
if (a == b) && (b == c) && (c == a)
	puts "Перед вами и равнобедренный, и равносторонний треугольник!"
elsif c ** 2 == a ** 2 + b ** 2
	puts "Перед вами прямоугольный треугольник!"
elsif (a == b) || (b == c) || (c == a)
	puts "Перед вами равнобедренный треугольник!"
else
	puts "Перед вами разносторонний треугольник!" #добавил это условие, чтобы программа выводила результат, если все стороны разной длины
end

