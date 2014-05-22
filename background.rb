require 'gosu'

class Game < Gosu::Window

	def tilefactor ; 10.0 ; end

	def initialize
		super 300, 300, false

		Gosu::enable_undocumented_retrofication

		@background_tiles = Gosu::Image.load_tiles(self, "media/grass.bmp", 8, 4, false)

		@refresh_cooldown = 0
	end

	def update
		if @refresh_cooldown <= 0 then
			draw_map
		else
			@refresh_cooldown -= 1
		end
	end

	def draw
		x = 0
		@background_tiles.each { |item| item.draw(x, 80, 0, tilefactor, tilefactor); x += (10 * tilefactor)}
		draw_map
	end

	def draw_map
		x = y = 0
		for j in 1..37
			for k in 1..74
				#tile_to_draw = @background_tiles[rand(8)]				
				tempTile = Tile.new(self, @background_tiles[rand(8)], x, y)
				tempTile.draw
				#tile_to_draw.draw(x, y, 0, tilefactor, tilefactor)
				y += 4
			end
			x += 8
			y = 0
		end
	end
end

class Tile
	attr_reader :x, :y

	def initialize(window, image, x, y)
		@cur_image = image
		@x, @y = x, y
	end

	def draw
		@cur_image.draw(x, y, 0, 10.0, 10.0)
	end
end

class Map
	def initialize(window, rows, cols)

	end

	def add_tile(tile)
	end

	def draw
	end
end

window = Game.new
window.show