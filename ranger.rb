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
	
	module EnemyIndexes
		Shadow = 0
		Unarmored = 1
		GoblinSpear = 2
		GoblinSword = 3
		GoblinBow = 4
		GoblinHammer = 5
		OrcSpear = 6
		OrcSword = 7
		OrcBow = 8
		OrcHammer = 9
	end
end

class Game < Gosu::Window

	def initialize
		super GameConstants::ScreenWidth, GameConstants::ScreenHeight, false
		Gosu::enable_undocumented_retrofication
		
		self.caption = GameConstants::Text::Caption

		@ranger = Ranger.new(self, 0, 0)
		
		@font = Gosu::Font.new(self, Gosu::default_font_name, 10)

		# load assets
		@item_images       = Gosu::Image.load_tiles(self, "media/items.bmp", GameConstants::ItemWidth, GameConstants::ItemHeight, false)
		@enemy_images      = Gosu::Image.load_tiles(self, "media/enemies.bmp", GameConstants::ItemWidth, GameConstants::ItemHeight, false)
		@background_images = Gosu::Image.load_tiles(self, "media/grass.bmp", GameConstants::TileWidth, GameConstants::TileHeight, false)
		@font_images       = Gosu::Image.load_tiles(self, "media/font.bmp", 8, 8, false)

		@projectiles = Array.new
		@arrow_cooldown = 0
		@dagger_cooldown = 0
		
		@enemies = Array.new
		@enemy_cooldown = 0
		
		@player_score  = 0
		@player_misses = 0

		#@background_rows = GameConstants::ScreenHeight / (GameConstants::TileHeight * GameConstants::SpriteFactor)
		#@background_cols = GameConstants::ScreenWidth / (GameConstants::TileWidth * GameConstants::SpriteFactor)
		@background_rows = GameConstants::ScreenHeight / (GameConstants::TileHeight)
		@background_cols = GameConstants::ScreenWidth / (GameConstants::TileWidth)


		@background_tiles = Array.new(@background_rows)
		for x in 0..@background_rows
			@background_tiles[x] = Array.new(@background_cols)
		end
		generate_background
	end

	def update
		move_x = move_y = 0

		if button_down? Gosu::KbUp then
			move_y -= @ranger.height
		end

		if button_down? Gosu::KbDown then
			move_y += @ranger.height
		end

		if button_down? Gosu::KbA then
			if @arrow_cooldown == 0 then
				@projectiles.push(Projectile.new(self, @item_images[GameConstants::ItemIndexes::Arrow], @ranger.x + 50, @ranger.y + (@ranger.height / 2)))
				@arrow_cooldown = 3
			end
			
			if @arrow_cooldown > 0 then
				@arrow_cooldown -= 1
			end
		end
		
		if button_down? Gosu::KbD then
			if @dagger_cooldown == 0 then
				@projectiles.push(Projectile.new(self, @item_images[GameConstants::ItemIndexes::Dagger], @ranger.x + 50, @ranger.y + (@ranger.height / 2)))
				@dagger_cooldown = 3
			end
			
			if @dagger_cooldown > 0 then
				@dagger_cooldown -= 1
			end
		end
		
		@ranger.move(move_x, move_y)
		@projectiles.each { |item| item.move(10) }
		
		@projectiles.reject! do |item|
		  if item.x > GameConstants::ScreenWidth then
			true
		  else
		    false
		  end
		end
		
		if @enemy_cooldown <= 0 then
		  @enemy_cooldown = 10
		  
		  @enemies.push(Enemy.new(self, @enemy_images[rand(10)], GameConstants::ScreenWidth - 8, rand(GameConstants::ScreenHeight)))
		end
		
		@enemy_cooldown -= 5
		@enemies.each { |enemy| enemy.move(2) }
		
		@enemies.reject! do |enemy|
		  #projectile_hit = false
		  @projectiles.each { |projectile| 
		  	#if check_collisions(projectile, enemy, 0, 0)
		  	if check_collisions_tutorial(projectile.x, projectile.y, enemy.x, enemy.y) then
				  @player_score += 10
				  @projectiles.delete(projectile)
				  @enemies.delete(enemy)
				end
		  }
		
		  if enemy.x < 0 then
		    @player_misses += 1
		    true
		  else
		    false
		  end
		end
	end

	def draw
		tile_x = tile_y = 0
		#for x in 0...@background_tiles.size
		#	for y in 0...@background_tiles.size
		for x in 0...@background_rows
			for y in 0...@background_cols
				@background_images[@background_tiles[x][y]].draw(tile_x, tile_y, ZOrder::Background, GameConstants::SpriteFactor * 2, GameConstants::SpriteFactor * 2)
				tile_y += (GameConstants::TileWidth * GameConstants::SpriteFactor)
			end
			tile_y = 0
			tile_x += (GameConstants::TileHeight * GameConstants::SpriteFactor)
		end

		@ranger.draw

		draw_score

		@font.draw("Arrows: #{@projectiles.count}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
		@font.draw("Enemies: #{@enemies.count}", 10, 30, 3, 1.0, 1.0, 0xffffff00)
		@font.draw("Score: #{@player_score}", 50, 10, 3, 1.0, 1.0, 0xffffff00)

		#@font.draw("Tile Size: #{@background_images[0].width} wide and #{@background_images[0].height} tall", 0, 200, 3, 1.0, 1.0, 0xffffff00)
		#@font.draw("Background Rows = #{@background_tiles.size}", 0, 200, 3, 1.0, 1.0, 0xffffff00)
		#@font.draw("Background Cols = #{@background_tiles[x].size}", 0, 225, 3, 1.0, 1.0, 0xffffff00)

		
		#x = 0
		#@item_images.each { |item| item.draw(x, 80, ZOrder::Entities, GameConstants::SpriteFactor, GameConstants::SpriteFactor); x += (10 * GameConstants::SpriteFactor)}
		#x = 0
		#@enemy_images.each { |item| item.draw(x, 150, ZOrder::Entities, GameConstants::SpriteFactor, GameConstants::SpriteFactor); x += (10 * GameConstants::SpriteFactor)}
		
		@projectiles.each { |item| item.draw }
		@enemies.each { |item| item.draw }
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end

	def check_collisions_tutorial(moving_x, moving_y, hit_x, hit_y)
		if Gosu::distance(moving_x, moving_y, hit_x, hit_y) < 35 then
			true
		else
			false
		end
	end

	def check_collisions(moving, being_hit, move_x, move_y)
		left1 = moving.x + move_x
		left2 = being_hit.x
		right1 = moving.x + move_x + moving.width
		right2 = being_hit.x + being_hit.width
		top1 = moving.y + move_y
		top2 = being_hit.y
		bottom1 = moving.y + move_y + moving.height
		bottom2 = being_hit.y + being_hit.height

		if bottom1 < top2
			return false
		end

		if top1 > bottom2
			return false
		end

		if right1 < left2
			return false
		end

		if left1 > right2
			return false
		end

		return true
	end

	def generate_background
		for x in 0...@background_tiles.size
			for y in 0...@background_tiles[x].size
				@background_tiles[x][y] = rand(0...@background_images.size)
			end
		end
	end

	def draw_score
		score_x = 200
		score_y = 0

		# S - 29
		@font_images[28].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
		score_x += 8 * GameConstants::SpriteFactor

		# C - 13
		@font_images[12].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
		score_x += 8 * GameConstants::SpriteFactor

		# O - 25
		@font_images[24].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
		score_x += 8 * GameConstants::SpriteFactor

		# R - 28
		@font_images[27].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
		score_x += 8 * GameConstants::SpriteFactor

		# E - 15
		@font_images[14].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
		score_x += 8 * GameConstants::SpriteFactor

		score_x = GameConstants::ScreenWidth - (8 * GameConstants::SpriteFactor)
		score_string = String.new(@player_score.to_s)
		# reverse the string and print the first character to the right
		# 150 becomes 051
		score_string.reverse!
		#@font.draw("score_string = '#{score_string}'", 0, 275, 10, 3.0, 3.0, 0xffffff00)
		for c in 0...score_string.length

			score_char = score_string[c].to_i

			#@font.draw("score_char = '#{score_char}'", 0, 280, 10, 3.0, 3.0, 0xffffff00)
			case score_char
			when 0
				font_index = 0
			when 1
				font_index = 1
			when 2
				font_index = 2
			when 3
				font_index = 3
			when 4
				font_index = 4
			when 5
				font_index = 5
			when 6
				font_index = 6
			when 7
				font_index = 7
			when 8
				font_index = 8
			when 9
				font_index = 9
			end

			#@font.draw("font_index = '#{font_index}'", 0, 250, 10, 3.0, 3.0, 0xffffff00)
			@font_images[font_index].draw(score_x, score_y, ZOrder::UI, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
			score_x -= 8 * GameConstants::SpriteFactor
		end

	end
end

class Ranger
	attr_reader :x, :y

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
	attr_reader :x, :y, :width, :height

	def initialize(window, image, x, y)
		@cur_image = image
		@x, @y = x, y
	end

	def move(x)
		@x += x
	end

	def draw
		@cur_image.draw_rot(x, y, ZOrder::Entities, 45.0, 0.5, 0.5, GameConstants::SpriteFactor, GameConstants::SpriteFactor)
	end

	def width
		@cur_image.width
	end

	def height
		@cur_image.height
	end
end

class Enemy
	attr_reader :x, :y, :width, :height
	
	def initialize(window, image, x, y)
		@cur_image = image
		
		if y < 8 then
		  y = 8
		end
		#if (y + self.height) > GameConstants::ScreenHeight then
		#  y = GameConstants::ScreenHeight - self.height
		#end
		
		@x, @y, = x, y
	end
	
	def move(x)
		@x -= x
	end
	
	def draw
		@cur_image.draw_rot(x, y, ZOrder::Entities, 1.0, 1.0, 1.0, -GameConstants::SpriteFactor, GameConstants::SpriteFactor)
	end
	
	def attack
		nil
	end
	
	def width
	  @cur_image.width
	end

	def height
		@cur_image.height
	end
end

window = Game.new
window.show