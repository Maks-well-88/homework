print "Как тебя зовут? "
my_name = gets.chomp
print "Пожалуйста, укажи свой рост в сантиметрах: "
height = gets.chomp
ideal_weight = (height.to_f - 110) * 1.15
if ideal_weight < 0
	puts "Ваш вес уже оптимальный."
else
	puts "#{my_name}, твой идеальный вес в килограммах - #{ideal_weight.round(2)}."
end