require 'ruby2d'

class Libellum

  attr_reader :grid_x, :grid_y,:title, :text
  attr_accessor :visum

  def initialize(grid_x, grid_y, tile_size, title, text)
    @grid_x = grid_x
    @grid_y = grid_y
    @tile_size = tile_size.to_i
    @title = title
    @text = text
    @visum = false

    @libellum = Circle.new(
        radius: @tile_size / 3,
        color: 'maroon',
        z: 100
    )
  end

  def update_sprite_viewport(camera_x_tile, camera_y_tile)
    if @visum
      @libellum.remove
      return
    end

    screen_x = (@grid_x - camera_x_tile) * @tile_size
    screen_y = (@grid_y - camera_y_tile) * @tile_size

    if screen_x >= 0 && screen_x < 1280 && screen_y >= 0 && screen_y < 720
      @libellum.x = screen_x + (@tile_size / 2)
      @libellum.y = screen_y + (@tile_size / 2)
      @libellum.add
    else
      @libellum.remove
    end
  end

  def remove_from_world
    @libellum.remove # not working
  end
end
