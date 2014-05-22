require 'gosu'

class Game < Gosu::Window

	def tilefactor ; 10.0 ; end

	def initialize
		super 300, 300, false

		Gosu::enable_undocumented_retrofication

		@background_tiles = Gosu::Image.load_tiles(self, "media/grass.bmp", 8, 4, false)
	end

	def update
	end

	def draw
		x = 0
		@background_tiles.each { |item| item.draw(x, 80, 0, tilefactor, tilefactor); x += (10 * tilefactor)}
	end
end

window = Game.new
window.show