# frozen_string_literal: true

require 'ruby2d'
set title: 'Verborum Iter',
    width: 800,
    height: 510,
    resizable: false,
    background: 'white'

@hero = Square.new(x: 10, y: 20, size: 16, color: 'red')

@x_speed = 0
@y_speed = 0

on :key do |event|
  case event.key
  when 'a'
    @x_speed = -2
    @y_speed = 0
    hero_move
  when 'd'
    @x_speed = 2
    @y_speed = 0
    hero_move
  when 'w'
    @x_speed = 0
    @y_speed = -2
    hero_move
  when 's'
    @x_speed = 0
    @y_speed = 2
    hero_move
  end
end

def hero_move
  @hero.x += @x_speed
  @hero.y += @y_speed
end

show
