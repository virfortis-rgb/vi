class Game

  def initialize
    @mundus = Mundus.new
    @hero = Hero.new(1, 1, @map.tile_size)
    @mundus.draw
    setup_inputs
  end

  def setup_inputs
    on :key_down do |event|
      next_x = @hero.grid_x
      next_y = @hero.grid_y

      case event.key
      when 'up'    then next_y -= 1
      when 'down'  then next_y += 1
      when 'left'  then next_x -= 1
      when 'right' then next_x += 1
      end

      # Ask the map instance if the destination is safe
      if @mundus.walkable?(next_x, next_y)
        @hero.move_to(next_x, next_y)
      end
    end
  end
end
