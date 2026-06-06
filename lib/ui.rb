require 'ruby2d'

class UI
  def initialize
    @text_box = Rectangle.new(
      x: 240, y: 500,
      width: 800, height: 160,
      color: [0.1, 0.1, 0.1, 0.95], # Near-black with subtle transparency
      z: 100 # Force it to float directly on top of everything
    )
    @text = Text.new("", x: 280, y: 525, size: 28, color: 'yellow', z: 101)
    @prompt = Text.new("[Press SPACE to continue]", x: 280, y: 575, size: 14, color: 'white', z: 101)
    hide_dialogue
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
end
