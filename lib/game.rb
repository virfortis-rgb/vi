require 'ruby2d'
require_relative './class_index'

class Game

  def initialize
    @current_level = 1
    @mundus = Mundus.new(@current_level)
    @camera = Camera.new(@mundus.grid, @mundus.csv_path)
    @start_position = LevelData::LEVELS[@current_level][:start_position]
    @hero = Hero.new(@start_position[:x], @start_position[:y], @mundus.tile_size)
    @ui = UI.new
    @state = :exploring
    @orbes = []
    spawn_orbes(@current_level)
    refresh_camera
    setup_inputs
    @ui.sacchus_monstratur("Orbes in saccho: #{@hero.sacchus.size}/#{@orbes.size}")
  end

  def spawn_orbes(level)
    LevelData::LEVELS[@current_level][:orbes].each do |v|
      @orbes << Orbs.new(v[:x], v[:y], @mundus.tile_size, v[:verbum])
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
    when 'left'
      next_x -= 1
      @hero.sprite.play animation: :walk, loop: true
    when 'up'
      next_y -= 1
      @hero.sprite.play animation: :walk, loop: true
    when 'down'
      next_y += 1
      @hero.sprite.play animation: :walk, loop: true
    when 'right'
      next_x += 1
      @hero.sprite.play animation: :walk, loop: true, flip: :horizontal
    end
    puts "Hero position: x = #{@hero.grid_x} | y = #{@hero.grid_y}"

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
    # TODO: accout for seen libella
    if @hero.grid_x == @libellum.grid_x && @hero.grid_y == @libellum.grid_y
      @libellum.visum = true
      @state = :literature
      @ui.libellum_monstratur(@libellum.title, @libellum.text)
      fac_mundum_novum
    end
  end

  def fac_mundum_novum
    @gate = LevelData::LEVELS[@current_level][:exit_gate]
    @camera.via_nova(@gate[:x], @gate[:y])
    puts "Level: #{@current_level}"
    puts "Exit gate: #{@gate}"
    if @hero.grid_x == @gate[:x] && @hero.grid_y == @gate[:y]
      @current_level += 1
      puts "Level up to level #{@current_level}!"
      load_mundum
    end
  end

  def load_mundum
    @mundus = Mundus.new(@current_level)
    puts 'New World Created!'
    @orbes.clear
    spawn_orbes(@current_level)
    puts 'New Orbes Spawned!'
    @start_position = LevelData::LEVELS[@current_level][:start_position]
    @hero.update_position(@start_position[:x], @start_position[:y])
    refresh_camera
  end

  def refresh_camera
    # 1. Tell mundus to shift its tiles around the hero, and get back the map's camera coordinates
    camera_offsets = @camera.update(@hero.grid_x, @hero.grid_y)

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
