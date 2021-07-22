print "Введите длину основания треугольника в сантиметрах: "
length = gets.chomp
print "Введите высоту треугольника в сантиметрах: "
height = gets.chomp
area = 0.5 * length.to_f * height.to_f
puts "Площадь треугольника составляет #{area.round(2)} см2."
