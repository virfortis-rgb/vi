require 'ruby2d'
require_relative './class_index'

class Game

  def initialize
    @current_level = 1
    @ui = UI.new
    load_mundum(@current_level)
    setup_inputs
  end

  def load_mundum(level)
    @data = LevelData::LEVELS[@current_level]
    raise "Ave! You've conquered all of Rome!" if @data.nil?

    # clean up before we start
    @camera&.clear_tiles
    @orbes&.each(&:remove_from_world) # Add cleanup safety to old items
    @libellum&.remove_from_world

    @mundus = Mundus.new(@current_level)
    puts 'New World Created!'
    @camera = Camera.new(@mundus.grid, @mundus.csv_path)
    puts 'New Camera Created!'
    start_position = @data[:start_position]
    @hero = Hero.new(start_position[:x], start_position[:y], @mundus.tile_size)


    @orbes = []
    spawn_orbes(@current_level)

    @libellum = nil
    @gate_opened = false
    @state = :exploring

    @ui.sacchus_monstratur("Orbes in saccho: #{@hero.sacchus.size}/#{@orbes.size}")
    refresh_camera
  end


  def spawn_orbes(level)
    @data[:orbes].each do |o|
      @orbes << Orbs.new(o[:x], o[:y], @mundus.tile_size, o[:verbum])
    end
    puts 'New Orbes Spawned!'
  end

  def setup_inputs
    Ruby2D::Window.on :key_down do |event|
      case @state
      when :exploring then handle_movement(event.key)
      when :dialogue then handle_dialogue_input(event.key)
      when :literature then  handle_literature_input(event.key)
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
    puts "Hero position: x = #{@hero.grid_x} | y = #{@hero.grid_y}" + "\r"

    if @mundus.walkable?(next_x, next_y) # how to refactor??
      @hero.update_position(next_x, next_y)
      check_orb_collisions
      check_libellum_collisions if @libellum
      check_for_new_level
      refresh_camera
    end
  end

  def handle_dialogue_input(key)
    if key == 'space'
      @ui.hide_dialogue
      @state = :exploring
      # check_for_libellum_spawn if @libellum.nil? && !@gate_opened
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
    
    libellum = LevelData::LEVELS[@current_level][:libellum]
    if @hero.sacchus.size == @orbes.size && @libellum.nil?
      @libellum = Libellum.new(
        libellum[:x], libellum[:y], @mundus.tile_size, 
        libellum[:title], libellum[:text]
        )
      puts "A sacred scroll has appeared in the city!"
    end
  end

  # def check_for_libellum_spawn
  # end

  def check_libellum_collisions
    return if @libellum.nil?

    if @hero.grid_x == @libellum.grid_x && @hero.grid_y == @libellum.grid_y
      @libellum.visum = true
      @state = :literature
      @ui.libellum_monstratur(@libellum.title, @libellum.text)
      @libellum.remove_from_world
      @libellum = nil
      viam_novam_apertitur
    end
  end

  def viam_novam_apertitur
    @gate = LevelData::LEVELS[@current_level][:exit_gate]
    @camera.via_nova(@gate[:x], @gate[:y])
    @gate_opened = true
    puts "New Gate opened!"
    puts "Level: #{@current_level}"
    puts "Exit gate: #{@gate}"
  end

  def check_for_new_level
    return unless @gate_opened

    if @hero.grid_x == @gate[:x] && @hero.grid_y == @gate[:y]
    @current_level += 1
    puts "Level up to level #{@current_level}!"
    load_mundum(@current_level)
    end
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
