require 'gosu'
require_relative 'game_window'

exit if defined?(Ocra)

window = GameWindow.new
window.show
