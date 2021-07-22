purchases = Hash.new

loop do
print "Введите название товара или введите 'стоп': "
product = gets.chomp
break if product == "стоп"
print "Введите количество товара: "
amount = gets.chomp.to_f
print "Введите цену за единицу товара: "
price = gets.chomp.to_i
purchases[product] = {"price" => price, "amount" => amount.round(1)}
end

total_amount = 0
puts purchases
purchases.each do |key, value| 
	puts "Итоговая сумма за #{key}: #{value["price"] * value["amount"]}"
	total_amount += value["price"] * value["amount"]
end
puts "Итоговая сумма всей покупки: #{total_amount}"