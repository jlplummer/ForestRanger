require 'gosu'

class Game < Gosu::Window

	def initialize
			super 600, 300, false
			Gosu::enable_undocumented_retrofication
			self.caption = "Knight Test"
			
			@knight_images = Gosu::Image.load_tiles(self, "media/knights_horsed.bmp", 19, 16, false)
			@dustcloud_images = Gosu::Image.load_tiles(self, "media/dust_cloud.bmp", 8, 8, false)

			@green_knight = Knight.new(self, 0, 10, @knight_images[0])
			@blue_knight = Knight.new(self, 0, 50, @knight_images[1])
			@red_knight = Knight.new(self, 0, 90, @knight_images[2])
			@knights = [@green_knight, @blue_knight, @red_knight]

			@green_dust_cloud = DustCloud.new(self, @green_knight.x, @green_knight.y + @green_knight.height, @dustcloud_images)
			@blue_dust_cloud = DustCloud.new(self, @red_knight.x, @red_knight.y + @red_knight.height, @dustcloud_images)
			@red_dust_cloud = DustCloud.new(self, @blue_knight.x, @blue_knight.y + @blue_knight.height, @dustcloud_images)
			
			@green_knight.add_cloud(@green_dust_cloud)
			@red_knight.add_cloud(@red_dust_cloud)
			@blue_knight.add_cloud(@blue_dust_cloud)
	end

	def update
		if button_down? Gosu::KbEscape
			close
		end

		@knights.each { |knight| 
			knight.move(3)
			knight.move_cloud
		}
		#@clouds.each { |cloud| cloud.update}
	end

	def draw
		@knights.each { |knight| 

			knight.draw
			#knight.draw_cloud
		}
		#@clouds.each {|cloud| cloud.draw}
	end

end

class Knight
	attr_reader :x, :y, :height

	def initialize(window, x, y, image)
		@cur_image = image
		@x, @y = x, y
		@start_y = y
		@direction_y = :up
		@speed_y = 1
		@direction_cooldown = 200
		@last_move = Gosu::milliseconds
		@cloud = nil
	end

	def draw
		@cur_image.draw(@x, @y, 1, 3, 3)
		@cloud.draw
	end

	def move(x)
		@x += x

		if (Gosu::milliseconds - @last_move) > @direction_cooldown
			if @direction_y == :up 
				@direction_y = :down
			else
				@direction_y = :up
			end

			@last_move = Gosu::milliseconds
		end

		if @direction_y == :up
			@y -= 1
		else
			@y += 1
		end
	end

	def height
		@cur_image.height
	end

	def add_cloud(cloud)
		@cloud = cloud
	end

	def move_cloud
		@cloud.move(@x, @y + @cur_image.height)
	end
end

class DustCloud
	def initialize(window, x, y, images)
		@x, @y = x, y
		@images = images
		@cur_image = images[0]
		@flip_cooldown = 500
		@last_flip = Gosu::milliseconds
		@ptr = 0
	end

	def move(x, y)
		# telling it specifically where to go, not incrementally
		@x, @y = x, y
	end

	def update
		if (Gosu::milliseconds - @last_flip) > @flip_cooldown
			if @ptr == 0
				@ptr = 1
			else
				@ptr = 0
			end

			@cur_image = @images[@ptr]
		end
	end

	def draw
		# draw behind knight
		@cur_image.draw(@x, @y, 0, 3, 3)
	end
end

Game.new.show