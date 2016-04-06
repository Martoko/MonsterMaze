# A class to paint the background
class Background
  def initialize(w, h)
    @w = w
    @h = h
  end

  def draw
    z = 0
    color = Gosu::Color.new(255, 189, 189, 189)
    Gosu.draw_rect(0, 0, @w, @h, color, z)
  end
end
