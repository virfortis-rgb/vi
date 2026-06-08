# frozen_string_literal: true

require 'ruby2d'
require_relative './lib/class_index'

set title: 'Verborum Iter',
    width: 1280,
    height: 720,
    resizable: false,
    # fullscreen: true,
    diagnostics: true,
    background: '#6f824f'

Game.new

show

# TODO: how to reset game?
# in reset method should also be revert mundus.csv to original
