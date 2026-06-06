require 'ruby2d'
require_relative './class_index'

class UI
  def initialize
    @hud = Text.new("", x: 20, y: 20, color: 'black', z: 10)
    @text_box = Rectangle.new(
      x: 240, y: 500,
      width: 800, height: 160,
      color: [0.1, 0.1, 0.1, 0.95], # Near-black with subtle transparency
      z: 100 # Force it to float directly on top of everything
    )
    @text = Text.new("", x: 280, y: 525, size: 28, color: 'yellow', z: 101)
    @prompt = Text.new("[Press SPACE to continue]", x: 280, y: 575, size: 14, color: 'white', z: 101)
    hide_dialogue
    @libellum_box = Rectangle.new(
      width: 1280, height: 720,
      color: [0.1, 0.1, 0.1, 0.95], # Near-black with subtle transparency
      z: 100 # Force it to float directly on top of everything
    )
    @libellum_title = Text.new("", x: 280, y: 515, size: 34, color: 'yellow', z: 101)
    @libellum_text = Text.new("", x: 280, y: 525, size: 28, color: 'yellow', z: 101)
    hide_libellum
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

  def sacchus_monstratur(text)
    @hud.text = text
  end

  def libellum_monstratur(title, text)
    @libellum_title = title
    @libellum_text = text
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
end
