class Mundus
  TILE_SIZE = 40

  attr_reader :tile_size

  def initialize
    @tile_size = TILE_SIZE
 
    # 0 = Walkable street, 1 = Stone wall / Building
    @grid = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 1, 1],
      [1, 1, 1, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
  end

  # Loops through the matrix to render the visual blocks of the world
  def draw
    @grid.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        if tile == 1
          Square.new(x: x * @tile_size, y: y * @tile_size, size: @tile_size, color: 'gray')
        else
          Square.new(x: x * @tile_size, y: y * @tile_size, size: @tile_size - 1, color: 'olive')
        end
      end
    end
  end

  # Helper method to verify Julius isn't walking into a Roman temple wall
  def walkable?(x, y)
    # Ensure player isn't moving out of map array bounds
    return false if y < 0 || y >= @grid.size
    return false if x < 0 || x >= @grid[0].size

    @grid[y][x] == 0
  end
end
