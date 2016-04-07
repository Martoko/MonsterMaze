require 'gosu'

# A transperant overlay with instructions
class InstructionsOverlay
  def initialize(game_window)
    @x = 0
    @y = 0
    @z = 3
    @w = game_window.width
    @h = game_window.height
    init_drawing
  end

  def init_drawing
    @bg_color = Gosu::Color.new(250, 20, 20, 20)
    @font = Gosu::Font.new(60)
    @font_color = Gosu::Color.new(255, 240, 240, 240)
    @text = ['User the arrow keys to move',
             'You heal over time, if not in combat',
             'Kill all the orcs!'].reverse
  end

  def draw
    Gosu.draw_rect(@x, @y, @w, @h, @bg_color, @z)

    relative_offset = 0.5 # Centers the text relative to its x and y values
    scale = 1
    @text.each.with_index do |line, i|
      @font.draw_rel(line, @w / 2, @h / 2 + 60 - i * 60, @z,
                     relative_offset, relative_offset, scale, scale, @font_color)
    end
  end
end
