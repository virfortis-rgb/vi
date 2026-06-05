require 'ruby2d'

class Hero
  attr_reader :grid_x, :grid_y

  def initialize(start_x, start_y, tile_size)
    @grid_x = start_x
    @grid_y = start_y
    @tile_size = tile_size
    @sprite = Square.new(
      x: @grid_x * @tile_size,
      y: @grid_x * @tile_size,
      z: 100,
      size: @tile_size,
      color: 'red'
    )
  end

  def move_to(target_x, target_y)
    @grid_x = target_x
    @grid_y = target_y

    @sprite.x = @grid_x * @tile_size
    @sprite.y = @grid_y * @tile_size
  end
end
