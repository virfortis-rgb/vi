class Mundus
  TILE_SIZE = 40
  VIEW_WIDTH_TILES = 10
  VIEW_HEIGHT_TILES = 10

  attr_reader :tile_size

  def initialize
    @tile_size = TILE_SIZE

    # 0 = Walkable street, 1 = Stone wall / Building
    @grid = [
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,1,1,0,0,1,0,0,1,1,1,1,1,0,0,0,0,0,1],
      [1,0,1,1,0,0,0,0,0,1,0,0,0,1,0,0,1,1,0,1],
      [1,0,0,0,0,0,0,1,1,1,0,0,0,1,0,0,1,1,0,1],
      [1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1],
      [1,0,1,1,1,1,0,0,0,1,0,0,0,0,0,0,1,0,0,1],
      [1,0,1,0,0,1,0,0,0,1,0,1,1,1,0,0,1,0,0,1],
      [1,0,1,0,0,1,0,0,0,1,0,1,0,1,0,0,1,0,0,1],
      [1,0,1,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1],
      [1,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
      [1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1],
      [1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    ]
    @rendered_tiles = []
  end

  # Loops through the matrix to render the visual blocks of the world
  def draw
    @grid.each_with_index do |row, y|
      @rendered_tiles[y] = []
      row.each_with_index do |tile_type, x|
        color = (tile_type == 1) ? 'gray' : 'olive'

        # We temporarily place them anywhere; 'update_camera' will slide them to the right spot
        @rendered_tiles[y][x] = Square.new(
          size: @tile_size - (tile_type == 1 ? 0 : 1),
          color: color
        )
      end
    end

  # Crucial Method: Adjusts where the squares are drawn based on hero's position
  def update_camera(player_grid_x, player_grid_y)
    # Calculate the camera offset (where the top-left corner of the screen is in world coordinates)
    # We subtract half the screen view width to keep the hero centered
    camera_x_tile = player_grid_x - (VIEW_WIDTH_TILES / 2)
    camera_y_tile = player_grid_y - (VIEW_HEIGHT_TILES / 2)

    # Optional: Clamp camera edges so it stops panning when hitting world boundaries
    camera_x_tile = camera_x_tile.clamp(0, @grid[0].size - VIEW_WIDTH_TILES)
    camera_y_tile = camera_y_tile.clamp(0, @grid.size - VIEW_HEIGHT_TILES)

    # Shift every single tile image based on the calculated camera offset
    @grid.each_with_index do |row, y|
      row.each_with_index do |_, x|
        tile_shape = @rendered_tiles[y][x]

        # New Position = (Your Map Position - Camera Offset) * Tile Size
        tile_shape.x = (x - camera_x_tile) * @tile_size
        tile_shape.y = (y - camera_y_tile) * @tile_size
      end
    end

    # Return the camera offsets so the Hero class can use them to position the hero
    [camera_x_tile, camera_y_tile]
  end

  # Helper method to verify the hero isn't walking into an obstacle
  def walkable?(x, y)
    # Ensure the hero isn't moving out of map array bounds
    return false if y < 0 || y >= @grid.size
    return false if x < 0 || x >= @grid[0].size
    @grid[y][x] == 0
  end
end
