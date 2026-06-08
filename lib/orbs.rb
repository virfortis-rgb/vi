require 'ruby2d'

class Orbs

  attr_reader :grid_x, :grid_y, :verbum, :sprite
  attr_accessor :visa

  def initialize(grid_x, grid_y, tile_size, verbum)
    @grid_x = grid_x
    @grid_y = grid_y
    @tile_size = tile_size.to_i
    @verbum = verbum
    @visa = false

    @sprite = Sprite.new(
      'assets/images/egg.png',
      height: 24,
      width: 24,
      clip_width: 96,
      clip_height: 96,
      time: 250,
      animations: {
        bob: 0..4
      }
    )
  end

  def update_sprite_viewport(camera_x_tile, camera_y_tile)
    if @visa
      @sprite.remove
      return
    end

    screen_x = (@grid_x - camera_x_tile) * @tile_size
    screen_y = (@grid_y - camera_y_tile) * @tile_size

    if screen_x >= 0 && screen_x < 1280 && screen_y >= 0 && screen_y < 720
      @sprite.x = screen_x + (@tile_size / 2)
      @sprite.y = screen_y + (@tile_size / 2)
      @sprite.add
    else
      @sprite.remove
    end
  end

  def remove_from_world
    @sprite.remove
  end
end
