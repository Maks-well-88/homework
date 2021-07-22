# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

# первый способ

letter = Hash.new
vowels = "аеёиоуыэюя"

x = 0
("а".."е").each do |i|
	x += 1
	letter[i] = x if vowels.include?(i)
end

letter["ё"] = 7

x = 7
("ж".."я").each do |i|
	x += 1
	letter[i] = x if vowels.include?(i)
end

puts letter

# второй способ покороче

new_letter = Hash.new
alphabet = %w(а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я)
vowels = "аеёиоуыэюя"

x = 0
alphabet.each do |i|
	x += 1
	new_letter[i] = x if vowels.include?(i)
end

puts new_letter

