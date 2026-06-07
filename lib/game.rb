require 'ruby2d'
require_relative './class_index'

INDEX_VERBORUM = [
  {
    x: 5,
    y: 3,
    verbum: 'cano'
  },
  {
    x: 12,
    y: 5,
    verbum: 'verum'
  },
  {
    x: 3,
    y: 15,
    verbum: 'et'
  },
  {
    x: 23,
    y: 21,
    verbum: 'arma'
  },
]

class Game

  def initialize
    @mundus = Mundus.new('assets/mundi/mundus.csv')
    @hero = Hero.new(3, 3, @mundus.tile_size) # because worlds change should I hard code tile_size?
    @ui = UI.new
    @state = :exploring
    @orbes = []
    spawn_initial_orbes
    refresh_camera
    setup_inputs
    @ui.sacchus_monstratur("Orbes in saccho: #{@hero.sacchus.size}/#{@orbes.size}")
  end

  def spawn_initial_orbes
    INDEX_VERBORUM.each do |v|
      @orbes << Orbs.new(v[:x], v[:y], @mundus.tile_size, v[:verbum]) # tile_size??
    end
  end

  def setup_inputs
    Ruby2D::Window.on :key_down do |event|
      case @state
      when :exploring
        handle_movement(event.key)
      when :dialogue
        handle_dialogue_input(event.key)
      when :literature
        handle_literature_input(event.key)
      end
    end
  end

  def handle_movement(key)
    next_x = @hero.grid_x
    next_y = @hero.grid_y

    case key
    when 'left'  then next_x -= 1
    when 'up'    then next_y -= 1
    when 'down'  then next_y += 1
    when 'right' then next_x += 1
    end

    if @mundus.walkable?(next_x, next_y) # how to refactor??
      @hero.update_position(next_x, next_y)
      check_orb_collisions
      check_libellum_collisions if @libellum
      refresh_camera
    end
  end

  def handle_dialogue_input(key)
    if key == 'space'
      @ui.hide_dialogue
      @state = :exploring
    end
  end

  def handle_literature_input(key)
    if key == 'space'
      @ui.hide_libellum
      @state = :exploring
    end
  end

  def check_orb_collisions
    @orbes.each do |orbs|
      next if orbs.visa

      if @hero.grid_x == orbs.grid_x && @hero.grid_y == orbs.grid_y
        orbs.visa = true
        @hero.sacchus << orbs
        @ui.sacchus_monstratur("Orbes in saccho: #{@hero.sacchus.size}/#{@orbes.size}")
        @state = :dialogue
        @ui.show_dialogue(orbs.verbum)
      end
    end

    # spawn libellum
    if @hero.sacchus.size == @orbes.size && @libellum.nil?
      @libellum = Libellum.new(29, 20, @mundus.tile_size, "Vergelii Aeneas", "Arma virumque canō")
      puts "A sacred scroll has appeared in the city!"
    end
  end

  def check_libellum_collisions
    if @hero.grid_x == @libellum.grid_x && @hero.grid_y == @libellum.grid_y
      @libellum.visum = true
      @state = :literature
      @ui.libellum_monstratur(@libellum.title, @libellum.text)
      # unlock new level
      fac_mundum_novum
    end
  end

  def fac_mundum_novum
    # open new path to mundus
    @mundus.via_nova(0, 7)
    # generate new munuds
    @mundus_secundus = Mundus.new('assets/mundi/mundus_secundus.csv')
  end

  def refresh_camera
    # 1. Tell mundus to shift its tiles around the hero, and get back the map's camera coordinates
    camera_offsets = @mundus.update_camera(@hero.grid_x, @hero.grid_y)

    # 2. Tell the hero to draw himself relative to those camera coordinates
    @hero.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    @orbes.each do |orb|
      orb.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    end
    if @libellum
      @libellum.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    end
  end
end
