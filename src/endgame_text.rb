require 'gosu'

class EndgameText
  def initialize(game_window, game_result = :win)
    @result = game_result
    @w = game_window.width
    @h = game_window.height
    @font = Gosu::Font.new(60)
    @text = 'Congratulations, you won!' if @result == :win
    @text = 'Game Over' if @result == :lose
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
    relative_offset = 0.5 # Centers the text
    @font.draw_rel(@text, @w / 2, @h / 2, z, relative_offset, relative_offset,
                   scale_x, scale_y, fnt_color)
  end
end
