require 'gosu'

module ZOrder
	Background, Entities, UI = *0..2
end

module GameConstants
	ScreenWidth  = 600
	ScreenHeight = 300

	PlayerHeight = 24
	PlayerWidth = 21 

	TileHeight = 4
	TileWidth  = 8

	ItemHeight = 8
	ItemWidth  = 8

	SpriteFactor = 3.0

	module Text
		Caption = "Forest Ranger"
	end

	module ItemIndexes
		Arrow     = 0
		FireArrow = 1
		Heart     = 2
		HalfHeart = 3
		Meat      = 4
		Shield    = 5
		Spear     = 6
		Longbow   = 7
		Longbow2  = 8
		Longbow3  = 9
		Dagger    = 10
		Torch     = 11
	end
end

class Game < Gosu::Window

	def initialize
		super GameConstants::ScreenWidth, GameConstants::ScreenHeight, false
		self.caption = GameConstants::Text::Caption

		@ranger = Ranger.new(self, 0, 0)

		# load assets
		@item_images = Gosu::Image.load_tiles(self, "media/items.bmp", GameConstants::ItemWidth, GameConstants::ItemHeight, false)

		Gosu::enable_undocumented_retrofication
	end

	def update
		move_x = move_y = 0

		if button_down? Gosu::KbUp then
			move_y -= @ranger.height
		end

		if button_down? Gosu::KbDown then
			move_y += @ranger.height
		end

		@ranger.move(move_x, move_y)
	end

	def draw
		@ranger.draw

		x = 0
		@item_images.each { |item| item.draw(x, 80, ZOrder::Entities, GameConstants::SpriteFactor, GameConstants::SpriteFactor); x += (10 * GameConstants::SpriteFactor)}
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end

end

class Ranger

	def initialize(window, x, y)
		@cur_image = Gosu::Image.new(window, "media/ranger.bmp", false)
		@x, @y = x, y
	end

	def draw
		@cur_image.draw(@x, @y, ZOrder::Entities, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
	end

	def move(x, y)
		@x += x
		@y += y
	end

	def height
		@cur_image.height
	end

	def width
		@cur_image.width
	end

end

class Projectile
	attr_reader :x, :y

	def initialize(image, x, y)
		@cur_image = image
		@x, @y = x, y
	end

	def update(x, y)
	end

	def draw
		@cur_image.draw(x, y, ZOrder::Entities, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
	end
end

window = Game.new
window.show