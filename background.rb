require 'gosu'

class Game < Gosu::Window

	def tilefactor ; 10.0 ; end

	def initialize
		super 300, 300, false

		Gosu::enable_undocumented_retrofication

		@background_tiles = Gosu::Image.load_tiles(self, "media/grass.bmp", 8, 4, false)
		@tile_objects = Array.new

		@background_tiles.each { |item| @tile_objects.push(item)}

		@refresh_cooldown = 0
		@draw_ok = true
	end

	def update
		@refresh_cooldown -= 1
		@draw_ok = true if @refresh_cooldown <= 0
	end

	def draw
		#x = 0
		#@background_tiles.each { |item| item.draw(x, 80, 0, tilefactor, tilefactor); x += (10 * tilefactor)}

		#@background_tiles[rand(@background_tiles.count)].draw(0, 150, 0, tilefactor, tilefactor)
		
		# I think the reason this is broke is not because I want to supress
		# drawing, but that I want to supress generating a new set of tiles
		if @draw_ok == true then
			draw_map
		end
	end

	def draw_map
		x = y = 0
		for j in 1..37
			for k in 1..74
				@background_tiles[rand(@background_tiles.count)].draw(x, y, 0, tilefactor, tilefactor)
				#tile_to_draw = @background_tiles[rand(8)]				
				#tempTile = Tile.new(self, @background_tiles[rand(8)], x, y)
				#tempTile.draw
				#tile_to_draw.draw(x, y, 0, tilefactor, tilefactor)
				y += 4
			end
			x += 8
			y = 0
		end

		@draw_ok = false
		@refresh_cooldown = 200
	end
end

Game.new.show