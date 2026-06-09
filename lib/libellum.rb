require 'ruby2d'

class Libellum

  attr_reader :grid_x, :grid_y,:title, :text, :sprite
  attr_accessor :visum

  def initialize(grid_x, grid_y, tile_size, title, text)
    @grid_x = grid_x
    @grid_y = grid_y
    @tile_size = tile_size.to_i
    @title = title
    @text = text
    @visum = false

    @sprite = Sprite.new(
      'assets/images/scroll.png',
      height: 32,
      width: 32,
      clip_width: 96,
      clip_height: 96,
      time: 250,
      animations: {
        bob: 0..3
      }
    )
  end

  def update_sprite_viewport(camera_x_tile, camera_y_tile)
    if @visum
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
    @sprite.remove # not working
  end
end
