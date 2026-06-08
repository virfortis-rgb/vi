require 'csv'

class Mundus
  TILE_SIZE = 40
  VIEW_WIDTH_TILES = 32
  VIEW_HEIGHT_TILES = 18

  attr_reader :tile_size, :grid, :csv_path

  def initialize(level)
    @tile_size = TILE_SIZE
    @csv_path = "assets/mundi/mundus_#{level}.csv"
    #raw_mundus_data = File.join(File.dirname(__FILE__), @csv_path)
    @grid = CSV.read(@csv_path).map { |row| row.map(&:to_i) }
  end

  def walkable?(x, y)
    # walkable: 1, 2, 3    return false if y < 0 || y >= @grid.size
    return false if x < 0 || x >= @grid[0].size
    @grid[y][x] == 1 || @grid[y][x] == 2 || @grid[y][x] == 3
  end
end
