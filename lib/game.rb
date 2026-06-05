class Game

  def initialize(attrs = {})
    @attrs = attrs
    reset!
  end

  def reset!
    @started = false
    @completed = false
    @paused = false
  end

  def start!
    @start ||= true
  end

  alias started? started

  def completed
    @completed = true
  end

  alias completed? completed

  def paused
    @paused = !paused?
  end

  alias paused? paused

# TODO: a method for saving ??
end
