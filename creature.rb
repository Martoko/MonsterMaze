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
    @turns_since_dmg = 0
    @passive_heal_val = 5
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

      if obj.is_a? Creature
        did_attack(obj)
        return true
      else
        did_collide_with(obj)
        return false
      end
    end

    @turns_since_dmg += 1
    true
  end

  def did_collide_with(obj)
    # Called when a collision occurs
  end

  def did_attack(obj)
    # Called when a collision occurs with another Creature
  end

  def passive_heal
    heal(@passive_heal_val) if @turns_since_dmg > 1
  end

  def heal(val)
    @health += val
    @health = @max_health if @health > @max_health
  end

  def take_dmg(dmg)
    @turns_since_dmg = 0
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

  def did_collide_with(_obj)
    puts 'player collided'
  end

  def did_attack(obj)
    obj.take_dmg(rand(dmg)) if obj.is_a? Enemy
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

  def did_attack(obj)
    obj.take_dmg(rand(dmg)) if obj.is_a? Player
  end

  def try_move(new_x, new_y)
    if @stamina < 1
      @stamina = @max_stamina
      return
    end

    did_move = super(new_x, new_y)

    @stamina -= 1 if did_move

    did_move
  end
end
