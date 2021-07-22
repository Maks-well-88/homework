# Заполнить массив числами фибоначчи до 100

fibonaci = [0, 1]

while fibonaci[-1] + fibonaci[-2] < 100
  num = fibonaci[-1] + fibonaci[-2]
  fibonaci << num
end

puts fibonaci