require 'gosu'

# A bar that goes from green to red according to the health of the creature
class HealthBar
  attr_accessor :cur_health, :max_health

  # Parent must have x, y, health and max_health
  def initialize(parent_creatue)
    @parent = parent_creatue
    @fg_color = Gosu::Color.new(255, 20, 170, 20)
    @bg_color = Gosu::Color.new(255, 170, 20, 20)
    @z = 2
    @w = 60
    @h = 7
    @rel_y = 64 - 7 - 2 # Puts the bar below the center of the sprite
  end

  def draw
    return if @parent.health == @parent.max_health

    health_percent = @parent.health.to_f / @parent.max_health

    fg_w = health_percent * @w
    bg_w = @w - fg_w
    bg_x = @parent.x + fg_w

    # Foreground (green)
    Gosu.draw_rect(@parent.x + @parent.w / 2 - @w / 2, @parent.y + @rel_y,
                   fg_w, @h, @fg_color, @z)
    # Background (red)
    Gosu.draw_rect(bg_x, @parent.y + @rel_y, bg_w, @h, @bg_color, @z)
  end
end
