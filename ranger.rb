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

	SpriteFactor = 3.0

	module Text
		Caption = "Forest Ranger"
	end
end

class Game < Gosu::Window

	def initialize
		super GameConstants::ScreenWidth, GameConstants::ScreenHeight, false
		self.caption = GameConstants::Text::Caption

		@ranger = Ranger.new(self, 0, 0)
	end

	def update
		move_x = move_y = 0

		if button_down? Gosu::KbUp then
			move_y -= GameConstants::PlayerHeight * GameConstants::SpriteFactor
		end

		if button_down? Gosu::KbDown then
			move_y += GameConstants::PlayerHeight * GameConstants::SpriteFactor
		end

		@ranger.move(move_x, move_y)
	end

	def draw
		@ranger.draw
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

	def shoot
	end

end

window = Game.new
window.show