# Заполнить массив числами от 10 до 100 с шагом 5

# первый способ
arr = []
i = 5
loop do
	arr << i += 5
	break if i == 100	
end
puts arr

# второй способ покороче
arr = (10..100).step(5).to_a
puts arr

