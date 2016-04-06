require 'gosu'

class InstructionsOverlay
  def initialize(game_window)
    @w = game_window.width
    @h = game_window.height
    @font = Gosu::Font.new(60)
    @text = ['User the arrow keys to move',
             'You heal over time, if not in combat',
             'Kill all the orcs!'].reverse
  end

  def draw
    x = 0
    y = 0
    z = 3
    bg_color = Gosu::Color.new(250, 20, 20, 20)
    Gosu.draw_rect(x, y, @w, @h, bg_color, z)

    fnt_color = Gosu::Color.new(255, 240, 240, 240)
    scale_x = 1
    scale_y = 1
    relative_offset = 0.5 # Centers the text relative to its x and y values
    @text.each.with_index do |line, i|
      @font.draw_rel(line, @w / 2, @h / 2 + 60 - i * 60, z,
                     relative_offset, relative_offset, scale_x, scale_y, fnt_color)
    end
  end
end
