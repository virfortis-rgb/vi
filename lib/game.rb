require 'ruby2d'
require_relative './class_index'

class Game

  def initialize
    @mundus = Mundus.new
    @hero = Hero.new(3, 3, @mundus.tile_size)
    refresh_camera
    setup_inputs
  end

  def setup_inputs
    Ruby2D::Window.on :key_down do |event|
      handle_movement(event.key)
    end
  end

  def handle_movement(key)
    next_x = @hero.grid_x
    next_y = @hero.grid_y

    case key
    when 'left'  
      next_x -= 1
      @hero.sprite.play animation: :walk, loop: true, flip: :horizontal
    when 'up'    
      next_y -= 1
      @hero.sprite.play animation: :walk, loop: true
    when 'down'  
      next_y += 1
      @hero.sprite.play animation: :walk, loop: true
    when 'right' 
      next_x += 1
      @hero.sprite.play animation: :walk, loop: true
    end

    if @mundus.walkable?(next_x, next_y)
      @hero.update_position(next_x, next_y)
      refresh_camera
    end
  end

  def refresh_camera
    # 1. Tell mundus to shift its tiles around the hero, and get back the map's camera coordinates
    camera_offsets = @mundus.update_camera(@hero.grid_x, @hero.grid_y)

    # 2. Tell the hero to draw himself relative to those camera coordinates
    @hero.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
  end
end
