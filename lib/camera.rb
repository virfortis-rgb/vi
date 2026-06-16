# class Camera
#   TILE_SIZE = 40
#   VIEW_WIDTH_TILES = 32
#   VIEW_HEIGHT_TILES = 18

#   def initialize(grid, csv_path)
#     @grid = grid
#     @csv_path =  csv_path
#     @tile_size = TILE_SIZE
#     @tiles_pool = Array.new(VIEW_HEIGHT_TILES) do
#       Array.new(VIEW_WIDTH_TILES) { Square.new(size: @tile_size) }
#     end
#   end

#   def update(player_grid_x, player_grid_y)
#     # 1. Figure out where the top-left corner of the camera should be in world coordinates
#     camera_x_tile = (player_grid_x - (VIEW_WIDTH_TILES / 2)).clamp(0, @grid[0].size - VIEW_WIDTH_TILES)
#     camera_y_tile = (player_grid_y - (VIEW_HEIGHT_TILES / 2)).clamp(0, @grid.size - VIEW_HEIGHT_TILES)

#     # 2. Loop ONLY through the size of the screen (10 iterations x 10 iterations = 100 total checks)
#     VIEW_HEIGHT_TILES.times do |screen_y|
#       VIEW_WIDTH_TILES.times do |screen_x|
#         # Match screen position to the corresponding actual world data position
#         world_x = camera_x_tile + screen_x
#         world_y = camera_y_tile + screen_y
#         tile_type = @grid[world_y][world_x]

#         # Fetch our recycled sprite from the pool
#         sprite = @tiles_pool[screen_y][screen_x]
#         # Re-position it on screen
#         sprite.x = screen_x * @tile_size
#         sprite.y = screen_y * @tile_size
#         # Change its color dynamically depending on what part of the world shifted into view
#         case tile_type
#         when 1 then sprite.color = 'white'
#         when 2 then sprite.color = 'olive'
#         when 3 then sprite.color = 'white'
#         when 4 then sprite.color = 'gray'
#         when 5 then sprite.color = 'gray'
#         when 6 then sprite.color = 'gray'
#         when 7 then sprite.color = 'gray'
#         when 8 then sprite.color = 'gray'
#         when 9 then sprite.color = 'green'
#         when 0 then sprite.color = 'green'
#         end
#       end
#     end
#     # Return camera offsets so the hero can update his relative viewport drawing
#     [camera_x_tile, camera_y_tile]
#   end


#   def via_nova(x, y)
#     # is this necessary?
#     # if y >= 0 && y < @grid.length && x >= 0 && x < @grid[0].length
#     @grid[y][x] = 1 # change to walkable path
#     # CSV.open(@csv_path, 'wb') do |csv|
#     #   @grid.each do |row|
#     #     csv << row
#     #   end
#     # end
#   end

#   def clear_tiles
#     @tiles_pool.each do |tile|
#       tile.each { |t| t.remove }
#     end
#     @tiles_pool.clear
#   end
# end

class Camera
  TILE_SIZE = 40
  VIEW_WIDTH_TILES = 32
  VIEW_HEIGHT_TILES = 18
  TILESET_PATH = 'assets/images/tiles.png'

  def initialize(grid, csv_path)
    @grid = grid
    @csv_path = csv_path
    @tile_size = TILE_SIZE

    # 1. Initialize our recycled pool using Image instances instead of Squares
    @tiles_pool = Array.new(VIEW_HEIGHT_TILES) do |screen_y|
      Array.new(VIEW_WIDTH_TILES) do |screen_x|
        Sprite.new(
          TILESET_PATH,
          x: screen_x * @tile_size,
          y: screen_y * @tile_size,
          width: @tile_size,
          height: @tile_size,
          # Bound the texture clip segment size to exactly one tile slice
          clip_width: @tile_size,
          clip_height: @tile_size,
          z: 0 # Map layers sit underneath characters and UI elements
        )
      end
    end
  end

  def update(player_grid_x, player_grid_y)
    # Figure out where the top-left corner of the camera should be in world coordinates
    camera_x_tile = (player_grid_x - (VIEW_WIDTH_TILES / 2)).clamp(0, @grid[0].size - VIEW_WIDTH_TILES)
    camera_y_tile = (player_grid_y - (VIEW_HEIGHT_TILES / 2)).clamp(0, @grid.size - VIEW_HEIGHT_TILES)

    # Loop ONLY through the viewport screen size dimensions
    VIEW_HEIGHT_TILES.times do |screen_y|
      VIEW_WIDTH_TILES.times do |screen_x|
        world_x = camera_x_tile + screen_x
        world_y = camera_y_tile + screen_y
        tile_type = @grid[world_y][world_x]

        # Fetch our recycled texture image actor from our memory pool
        image_tile = @tiles_pool[screen_y][screen_x]

        # Determine how far to slide our image crop window to catch the right texture
        # Example: tile_type 3 will extract the crop starting at pixel position 120 (3 * 40)
        texture_offset_x = tile_type * @tile_size

        # Update the crop region boundaries on our image sheet asset
        image_tile.clip_x = texture_offset_x
        image_tile.clip_y = 0

        # Redraw optimization: guarantee the sprite is actively appended onto Ruby2D canvas
        image_tile.add
      end
    end

    # Return camera offsets so the hero can update his relative viewport drawing
    [camera_x_tile, camera_y_tile]
  end

  def via_nova(x, y)
    @grid[y][x] = 0 # change to walkable path
  end

  def clear_tiles
    @tiles_pool.each do |row|
      row.each { |img| img.remove }
    end
    @tiles_pool.clear
  end
end
