require 'ruby2d'
require_relative './class_index'

class Game

  def initialize
    @current_level = 1
    @ui = UI.new
    @unlocked_levels = {}
    @collected_orbes = []
    @collected_libella = []
    load_mundum(@current_level)
    @menu_options = ["Start Game", "Exit Game"]
    @menu_index = 0
    @state = :menu
    @ui.show_menu(@menu_options, @menu_index)
    @ui.update_menu_highlight(@menu_index)
    setup_inputs
  end

  def setup_inputs
    Ruby2D::Window.on :key_down do |event|
      case @state
      when :menu then handle_menu(event.key)
      when :story then handle_story(event.key)
      when :exploring then handle_movement(event.key)
      when :dialogue then handle_dialogue_input(event.key)
      when :notification then handle_notification(event.key)
      when :literature then  handle_literature_input(event.key)
      end
    end
  end

  def handle_menu(key)
    case key
    when 'up'
      @menu_index = (@menu_index - 1) % @menu_options.size # 0
      @ui.update_menu_highlight(@menu_index)
    when 'down'
      @menu_index = (@menu_index + 1) % @menu_options.size # 1
      @ui.update_menu_highlight(@menu_index)
    when "space" 
      execute_menu
    end
  end

  def execute_menu
    case @menu_index
    when 0
      @ui.hide_menu
      @ui.show_story_menu 
      @state = :story
    when 1
      Ruby2D::Window.close
    end
  end

  def handle_story(key)
    case key
    when 'space' 
      @ui.hide_story_menu
      scenes = StoryScenes::SCENES
      scenes.each do |scene| # DOES NOT WORK : TODO 
        @state = :literature
        @ui.libellum_monstratur(scene[:title], scene[:text])
      end
    when 's'
      @ui.hide_story_menu
      load_mundum(@current_level)
      @state = :exploring
    end
  end

  def handle_movement(key)
    next_x, next_y = @hero.grid_x, @hero.grid_y
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
    when 'm' # after second time, doesn't work any more
      @state = :menu
      @ui.show_menu(@menu_options, @menu_index = 0)
    end
    print "Hero position: x = #{@hero.grid_x} | y = #{@hero.grid_y}" + "\r"
    $stdout.flush 

    if @mundus.walkable?(next_x, next_y) # how to refactor??
      @hero.update_position(next_x, next_y)
      check_orb_collisions
      check_libellum_collisions if @libellum
      check_portals      
      refresh_camera
    end

    if game_end
      @ui.show_dialogue("Congratulations! You did it!")
      @state = :menu
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

  def handle_notification(key)
    if key == 'space'
      @ui.hide_notification
      @state = :exploring
    end
  end

  def load_mundum(level, custom_spawn_x = nil, custom_spawn_y = nil)
    @current_level = level
    @data = LevelData::LEVELS[@current_level]
    raise "Ave! You've conquered all of Rome!" if @data.nil?
    @camera&.clear_tiles
    @orbes&.each(&:remove_from_world)
    @libellum&.remove_from_world 
    @mundus = Mundus.new(@current_level)
    @camera = Camera.new(@mundus.grid, @mundus.csv_path)
    spawn_x = custom_spawn_x || 3
    spawn_y = custom_spawn_y || 3
    @hero = Hero.new(spawn_x, spawn_y, @mundus.tile_size)
    @orbes = []
    spawn_orbes(@current_level)
    @libellum = nil
    @libellum_id = nil
    if @unlocked_levels[@current_level] == true
      @data[:portals].each { |p| @camera.via_nova(p[:x], p[:y]) }
    end
    @ui.sacchus_monstratur(@current_level, @hero.sacchus.size, @orbes.size)
    refresh_camera
  end

  def spawn_orbes(level)
    @data[:orbes].each do |o|
      id = "#{level}_#{o[:verbum]}"
      next if @collected_orbes.include?(id)
      @orbes << orbs = Orbs.new(o[:x], o[:y], @mundus.tile_size, o[:verbum])
      orbs.sprite.play animation: :bob, loop: true
    end
  end

  def check_orb_collisions
    @orbes.each do |orbs|
      next if orbs.visa

      if @hero.grid_x == orbs.grid_x && @hero.grid_y == orbs.grid_y
        orbs.visa = true
        @hero.sacchus << orbs
        id = "#{@current_level}_#{orbs.verbum}"
        @collected_orbes << id
        @ui.sacchus_monstratur(@current_level, @hero.sacchus.size, @orbes.size)
        @state = :dialogue
        @ui.show_dialogue(orbs.verbum)
      end
    end
    spawn_libellum unless @collected_libella.include?(@libellum_id) # get id for libellum
  end

  def spawn_libellum
    libellum = @data[:libellum]
    if @hero.sacchus.size == @orbes.size && @state == :exploring # keep an eye, might cause issues
      @libellum = Libellum.new(
        libellum[:x], libellum[:y], @mundus.tile_size, 
        libellum[:title], libellum[:text]
        )
      @libellum_id = "#{@current_level}_#{@libellum.title}"
      @libellum.sprite.play animation: :bob, loop: true
      unless @collected_libella.include?(@libellum_id)
        @state = :notification
        @ui.show_notification("A sacred scroll has appeared in the city!")
      end
      @collected_libella << @libellum_id
    end
  end

  def check_libellum_collisions
    return if @libellum.nil?

    if @hero.grid_x == @libellum.grid_x && @hero.grid_y == @libellum.grid_y
      @libellum.visum = true
      @state = :literature
      @ui.libellum_monstratur(@libellum.title, [@libellum.text])
      @libellum.remove_from_world
      @libellum = nil
      portae_apertitur
    end
  end

  def portae_apertitur
    @unlocked_levels[@current_level] = true
    @data[:portals].each { |p| @camera.via_nova(p[:x], p[:y]) }
       # TODO: same method in load_mundum??
    puts "Levels opened up!"
  end

  def check_portals
    @data[:portals].each do |p| 
      if @hero.grid_x == p[:x] && @hero.grid_y == p[:y]
      load_mundum(p[:target_level], p[:spawn_x], p[:spawn_y])
        @state = :notification
        @ui.show_notification("Level up to level #{@current_level}!")
      break
      end
    end
  end

  def refresh_camera
    camera_offsets = @camera.update(@hero.grid_x, @hero.grid_y)
    @hero.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    @orbes.each { |orb| orb.update_sprite_viewport(camera_offsets[0], camera_offsets[1]) }
    if @libellum
      @libellum.update_sprite_viewport(camera_offsets[0], camera_offsets[1])
    end
  end

  def game_end
    all_orbes = 0 
    LevelData::LEVELS.each { |set| all_orbes += set.size }
    conditions = @current_level == LevelData::LEVELS.size && @collected_orbes.size == all_orbes && @collected_libella == LevelData::LEVELS.size
    return true if conditions
  end
end