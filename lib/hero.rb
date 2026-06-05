require 'ruby2d'

class Hero < Sprite
  def initialize
    super(
      x: 20,
      y: 80,
      size: 32,
      color: 'red'
    )
  end
end
