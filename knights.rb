require 'gosu'

class Game < Gosu::Window

	def initialize
			super 600, 300, false
			Gosu::enable_undocumented_retrofication
			self.caption = "Knight Test"
			
			@knight_images = Gosu::Image.load_tiles(self, "media/knights_horsed.bmp", 19, 16, false)

			@green_knight = Knight.new(self, 0, 10, @knight_images[0])
			@blue_knight = Knight.new(self, 0, 50, @knight_images[1])
			@red_knight = Knight.new(self, 0, 90, @knight_images[2])

			@knights = [@green_knight, @blue_knight, @red_knight]
	end

	def update
		if button_down? Gosu::KbEscape
			close
		end

		@knights.each { |knight| knight.move(3)}
	end

	def draw

		@knights.each { |knight| knight.draw}

		# @green_knight.draw
		# @blue_knight.draw
		# @red_knight.draw
	end

end

class Knight

	def initialize(window, x, y, image)
		@cur_image = image
		@x, @y = x, y
		@start_y = y
		@direction_y = :up
	end

	def draw
		@cur_image.draw(@x, @y, 1, 3, 3)
	end

	def move(x)
		@x += x

		#magic number here means how far on Y it's allowed to move
		if @direction_y == :up 
			@y -= 10
			@direction_y = :down
		else
			@y += 10
			@direction_y = :up
		end
	end
end

Game.new.show