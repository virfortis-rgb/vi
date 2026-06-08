require 'csv'

class Mundus
  TILE_SIZE = 40
  VIEW_WIDTH_TILES = 32
  VIEW_HEIGHT_TILES = 18

  attr_reader :tile_size

  def initialize(csv_path)
    @tile_size = TILE_SIZE
    @csv_path = csv_path
    #raw_mundus_data = File.join(File.dirname(__FILE__), @csv_path)
    @grid = CSV.read(@csv_path).map { |row| row.map(&:to_i) }
    @sprites_pool = Array.new(VIEW_HEIGHT_TILES) do
      Array.new(VIEW_WIDTH_TILES) { Square.new(size: @tile_size) }
    end
  end

def update_camera(player_grid_x, player_grid_y)
  # 1. Figure out where the top-left corner of the camera should be in world coordinates
  camera_x_tile = (player_grid_x - (VIEW_WIDTH_TILES / 2)).clamp(0, @grid[0].size - VIEW_WIDTH_TILES)
  camera_y_tile = (player_grid_y - (VIEW_HEIGHT_TILES / 2)).clamp(0, @grid.size - VIEW_HEIGHT_TILES)

  # 2. Loop ONLY through the size of the screen (10 iterations x 10 iterations = 100 total checks)
  VIEW_HEIGHT_TILES.times do |screen_y|
    VIEW_WIDTH_TILES.times do |screen_x|
      # Match screen position to the corresponding actual world data position
      world_x = camera_x_tile + screen_x
      world_y = camera_y_tile + screen_y
      tile_type = @grid[world_y][world_x]

      # Fetch our recycled sprite from the pool
      sprite = @sprites_pool[screen_y][screen_x]
      # Re-position it on screen
      sprite.x = screen_x * @tile_size
      sprite.y = screen_y * @tile_size
      # Change its color dynamically depending on what part of the world shifted into view
      case tile_type
      when 1 then sprite.color = 'white'
      when 2 then sprite.color = 'olive'
      when 3 then sprite.color = 'white'
      when 4 then sprite.color = 'grey'
      when 5 then sprite.color = 'grey'
      when 6 then sprite.color = 'grey'
      when 7 then sprite.color = 'grey'
      when 8 then sprite.color = 'grey'
      when 9 then sprite.color = 'green'
      when 0 then sprite.color = 'green'
      end
    end
  end

    # Return camera offsets so Julius can update his relative viewport drawing
    [camera_x_tile, camera_y_tile]
  end

  def via_nova(x, y)
    @grid[y][x] = 0
    CSV.open(@csv_path, 'wb') do |csv|
      @grid.each do |row|
        csv << row
      end
    end
  end

  # Helper method to verify the hero isn't walking into an obstacle
  def walkable?(x, y)
    # Ensure the hero isn't moving out of map array bounds
    return false if y < 0 || y >= @grid.size
    return false if x < 0 || x >= @grid[0].size
    @grid[y][x] == 0
  end
end
