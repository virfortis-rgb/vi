require 'ruby2d'

class Orbs

  attr_reader :grid_x, :grid_y, :verbum
  attr_accessor :visa

  def initialize(grid_x, grid_y, tile_size, verbum)
    @grid_x = grid_x
    @grid_y = grid_y
    @tile_size = tile_size.to_i
    @verbum = verbum
    @visa = false

    @orbs_simplex = Circle.new(
      radius: @tile_size / 3,
      color: 'yellow'
    )
  end

  def update_sprite_viewport(camera_x_tile, camera_y_tile)
    if @visa
      @orbs_simplex.remove
      return
    end

    screen_x = (@grid_x - camera_x_tile) * @tile_size
    screen_y = (@grid_y - camera_y_tile) * @tile_size

    if screen_x >= 0 && screen_x < 1280 && screen_y >= 0 && screen_y < 720
      @orbs_simplex.x = screen_x + (@tile_size / 2)
      @orbs_simplex.y = screen_y + (@tile_size / 2)
      @orbs_simplex.add
    else
      @orbs_simplex.remove
    end
  end

  def remove_from_world
    @orbs_simplex.remove
  end
end
