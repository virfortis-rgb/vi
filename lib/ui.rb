require 'ruby2d'
require_relative './class_index'

class UI
  def initialize
    # refactor!
    @menu_box = Rectangle.new(width: 1280, height: 720, color: [0.1, 0.1, 0.1, 0.88], z: 100)
    @menu_title = Text.new("Menu", x: 280, y: 320, size: 48, color: 'yellow', z: 101)
    @menu_text_options = []
    @story_menu_box = Rectangle.new(width: 1280, height: 720, color: [0.1, 0.1, 0.1, 0.88], z: 100)
    @story_menu = Text.new("space - play, s - skip", x: 280, y: 320, size: 48, color: 'yellow', z: 101)
    @hud = Text.new("", x: 20, y: 20, color: 'black', z: 10)
    @text_box = Rectangle.new(x: 240, y: 500, width: 800, height: 160, color: [0.1, 0.1, 0.1, 0.95], z: 100)
    @text = Text.new("", x: 280, y: 525, size: 28, color: 'yellow', z: 101)
    @prompt = Text.new("[Press SPACE to continue]", x: 280, y: 575, size: 14, color: 'white', z: 101)
    hide_dialogue
    @libellum_box = Rectangle.new( width: 1280, height: 720, color: [0.1, 0.1, 0.1, 0.95], z: 100)
    @libellum_title = Text.new("", x: 280, y: 320, size: 48, color: 'yellow', z: 101)
    @libellum_text = Text.new("", x: 280, y: 400, size: 28, color: 'white', z: 101)
    hide_libellum
    @notification_box = Rectangle.new(x: 240, y: 500, width: 800, height: 160, color: [0.1, 0.1, 0.1, 0.95], z: 100)
    @notification = Text.new("", x: 280, y: 525, size: 20, color: 'blue', z: 101)
    hide_notification
  end

  def play_story(title, text = [])
    box = Rectangle.new(width: 1280, height: 720, color: [0.1, 0.1, 0.1, 0.88], z: 100)
    title = Text.new(title, x: 280, y: 400, size: 28, color: 'white', z: 101)
    content = text.map { |t| Text.new(t, x: 280, y: 400, size: 28, color: 'white', z: 101) }
    box.add
    title.add
    content.each { |c| c.add }
    sleep(5)
    box.remove
    title.remove
    content.each { |c| c.remove }
  end

  def show_menu(options, index)
    options.each do |o|
      @menu_text_options << Text.new("#{index + 1}. #{o}", x: 280, y: 400 + (index * 50), size: 28, color: 'white', z: 101)
      index += 1
    end
    @menu_box.add
    @menu_title.add
    @menu_text_options.each { |o| o.add}
    @prompt.add
  end

  def update_menu_highlight(index)
    @menu_text_options.each { |o| o.color = 'white' }
    @menu_text_options[index].color = 'yellow'
  end

  def hide_menu
    @menu_box.remove
    @menu_title.remove
    @menu_text_options.each { |o| o.remove}
    @prompt.remove
  end

  def show_story_menu
    @story_menu_box.add
    @story_menu.add
  end

  def hide_story_menu
    @story_menu_box.remove
    @story_menu.remove
  end

  def show_dialogue(verbum)
    @text.text = verbum
    @text_box.add
    @text.add
    @prompt.add
  end

  def hide_dialogue
    @text_box.remove
    @text.remove
    @prompt.remove
  end

  def sacchus_monstratur(level, sacchus, orbes_size)
    @hud.text = "Level: #{level} || Orbes in saccho: #{sacchus}/#{orbes_size}"
  end

  def libellum_monstratur(title, text)
    @libellum_title.text = title
    @libellum_text.text = text
    @libellum_box.add
    @libellum_title.add
    @libellum_text.add
    @prompt.add
  end

  def hide_libellum
    @libellum_box.remove
    @libellum_title.remove
    @libellum_text.remove
    @prompt.remove
  end

  def show_notification(text)
    @notification.text = text
    @notification_box.add
    @notification.add
    @prompt.add
  end

  def hide_notification
    @notification_box.remove
    @notification.remove
    @prompt.remove
  end
end
