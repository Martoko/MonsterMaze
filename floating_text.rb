# Text that floats upwards and fades out
class FloatingText < GameObject
  def initialize(text, x, y)
    @x = x
    @y = y
    @opacity = 255
    @font = Gosu::Font.new(40)
    @text = text
  end

  def update
    @y -= 0.3
    @opacity -= (300 - @opacity) / 20.0

    @@objs.delete self if @opacity <= 0
  end

  def draw
    z = 2
    color = Gosu::Color.new(@opacity, 170, 20, 20)
    scale_x = 1
    scale_y = 1
    relative_offset = 0.5
    @font.draw_rel(@text, @x, @y, z, relative_offset, relative_offset,
                   scale_x, scale_y, color)
  end
end
