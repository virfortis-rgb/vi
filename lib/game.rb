require 'ruby2d'
require_relative './class_index'

INDEX_VERBORUM = [
  {
    x: 5,
    y: 3,
    verbum: 'cano'
  },
  {
    x: 12,
    y: 5,
    verbum: 'verum'
  },
  {
    x: 2,
    y: 12,
    verbum: 'et'
  },
  {
    x: 25,
    y: 15,
    verbum: 'arma'
  },
]

class Game

  def initialize
    @mundus = Mundus.new
    @hero = Hero.new(2, 2, @mundus.tile_size)
    @orbes = []
    spawn_initial_orbes
    refresh_camera
    setup_inputs
  end

  def spawn_initial_orbes
    INDEX_VERBORUM.each do |v|
      @orbes << Orbs.new(v[:x], v[:y], @mundus.tile_size, v[:verbum])
    end
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
    when 'left'  then next_x -= 1
    when 'up'    then next_y -= 1
    when 'down'  then next_y += 1
    when 'right' then next_x += 1
    end

    if @mundus.walkable?(next_x, next_y)
      @hero.update_position(next_x, next_y)
      check_orb_collisions
      refresh_camera
    end
  end

  def check_orb_collisions
    @orbes.each do |orb|
      next if orb.visa

      if @hero.grid_x == orb.grid_x && @hero.grid_y == orb.grid_y
        orb.visa = true

        puts "--------------------------------------------------"
        puts "✨ ORBS VISA! ✨"
        puts "Latin: #{orb.verbum}"
        puts "--------------------------------------------------"
      end
    end
  end

  def refresh_camera
    # 1. Tell mundus to shift its tiles around the hero, and get back the map's camera coordinates
    camera_offsets = @mundus.update_camera(@hero.grid_x, @hero.grid_y)

    # 2. Tell the hero to draw himself relative to those camera coordinates
    @hero.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    @orbes.each do |orb|
      orb.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    end
  end
end
