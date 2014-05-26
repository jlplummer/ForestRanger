screen_height = 300
screen_width = 600
tile_height = 4
tile_width = 8

max_rows = screen_height / tile_height
max_cols = screen_width / tile_width

rows = Array.new(max_rows)

for x in 0..max_rows
	rows.push(Array.new(max_cols))
end

for x in 0..rows.count
	for y in 0..max_cols
		rows[x][y] = 1
	end
end

puts rows 