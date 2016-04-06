require 'gosu'

# A bar that goes from green to red according to the health of the creature
class HealthBar
  attr_accessor :cur_health, :max_health

  # Parent must have x, y, health and max_health
  def initialize(parent)
    @parent = parent
    @overlay_color = Gosu::Color.new(255, 20, 170, 20)
    @bg_color = Gosu::Color.new(255, 170, 20, 20)
    @w = 60
    @h = 7
    @rel_y = 64 - 7 - 2
  end

  def draw
    return if @parent.health == @parent.max_health
    z = 2

    cur = @parent.health
    max = @parent.max_health

    overlay_w = cur.to_f / max * @w
    bg_w = @w - overlay_w
    bg_x = @parent.x + overlay_w

    # Overlay (green)
    Gosu.draw_rect(@parent.x + @parent.w / 2 - @w / 2, @parent.y + @rel_y,
                   overlay_w, @h, @overlay_color, z)
    # Background (red)
    Gosu.draw_rect(bg_x, @parent.y + @rel_y, bg_w, @h, @bg_color, z)
  end
end
