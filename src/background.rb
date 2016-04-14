# A class to paint the background
class Background
  def initialize(game_window)
    @w = game_window.width
    @h = game_window.height
  end

  def draw
    z = 0
    color = Gosu::Color.new(255, 189, 189, 189)
    Gosu.draw_rect(0, 0, @w, @h, color, z)
  end
end
