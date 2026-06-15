# frozen_string_literal: true

require 'ruby2d'
require_relative './lib/class_index'

set title: 'Verborum Iter',
    width: 1280,
    height: 720,
    resizable: false,
    fullscreen: true,
    diagnostics: true,
    background: 'white'

Game.new

show

# TODO: how to save game?
