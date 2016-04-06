require_relative 'game_object'
require_relative 'health_bar'

# Represents an object with health AKA the player and enemies
class Creature < GameObject
  attr_accessor :health, :max_health, :dmg
  def initialize
    @max_health = 10
    @health = @max_health
    @healthbar = HealthBar.new(self)
    @dmg = 10
  end

  def try_move(new_x, new_y)
    old_x = x
    old_y = y
    @x = new_x
    @y = new_y
    @@objs.each do |obj|
      next if obj == self
      next unless obj.respond_to? :overlaps?
      next unless obj.solid == true
      next unless obj.overlaps?(self)

      @x = old_x
      @y = old_y
      did_collide_with(obj)
      break
    end
  end

  def heal(val)
    @health += val
    @health = @max_health if @health > @max_health
  end

  def take_dmg(dmg)
    @health -= dmg
    @@objs << FloatingText.new(dmg.to_s, @x + @w / 2, @y)

    @@objs.delete(self) if @health <= 0
  end

  def draw
    super()
    @healthbar.draw
  end
end

# Represents a player square
class Player < Creature
  def initialize(x, y)
    super()
    @x = x
    @y = y
    @w = 64
    @h = 64
    @max_health = 20
    @health = @max_health
    @solid = true
    @image = Gosu::Image.new('img/visored-helm.png')
  end

  def try_move(new_x, new_y)
    super(new_x, new_y)
    did_move = @x == new_x && @y == new_y
    if did_move
      heal(rand(5))
    end
  end

  def did_collide_with(obj)
    puts 'player collided'
    if obj.is_a? Enemy
      obj.take_dmg(rand(dmg)) if obj.is_a? Enemy
      if obj.health > 0
        self.take_dmg(rand(obj.dmg))
      end
    end
  end
end

# Represents an enemy
class Enemy < Creature
  def initialize(x, y)
    super()
    @max_health = 50
    @health = @max_health
    @dmg = 5
    @x = x
    @y = y
    @w = 64
    @h = 64
    @max_stamina = 4
    @stamina = @max_stamina
    @solid = true
    @image = Gosu::Image.new('img/orc-head.png')
  end

  def did_collide_with(_obj)
    puts 'enemy collided'
  end

  def try_move(new_x, new_y)
    if @stamina < 1
      @stamina = @max_stamina
      return
    end

    super(new_x, new_y)
    did_move = @x == new_x && @y == new_y
    if did_move
      @stamina -= 1
      heal(rand(5))
    end
  end
end
