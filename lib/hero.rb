require 'ruby2d'

class Hero
  attr_reader :grid_x, :grid_y, :sacchus, :sprite

  def initialize(start_x, start_y, tile_size)
    @grid_x = start_x
    @grid_y = start_y
    @tile_size = tile_size
    @sacchus = []
    @sprite = Sprite.new(
      'assets/images/duck.png',
      x: @grid_x * @tile_size,
      y: @grid_x * @tile_size,
      height: 40,
      width: 40,
      clip_width: 128,
      clip_height: 128,
      time: 250,
      animations: {
        walk: 0..1
      }
    )
  end

  # 1. Update internal grid position
  def update_position(target_x, target_y)
    @grid_x = target_x
    @grid_y = target_y
  end

  # 2. Update screen visual location relative to camera offset
  def update_sprite_viewport(camera_x_tile, camera_y_tile)
    @sprite.x = (@grid_x - camera_x_tile) * @tile_size
    @sprite.y = (@grid_y - camera_y_tile) * @tile_size
  end
end
