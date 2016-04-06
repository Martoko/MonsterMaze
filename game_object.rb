# An abstract class to define basic function for objects
class GameObject
  attr_accessor :x, :y, :w, :h, :solid
  def self.set_objects(objs)
    @@objs = objs
  end

  def draw
    @z ||= 1
    @image.draw(@x, @y, @z)
  end

  def overlaps?(other)
    @x == other.x && @y == other.y
  end

  def did_collide_with(obj)
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

      did_collide_with(obj)
      @x = old_x
      @y = old_y
      break
    end
  end
end

# Represents the player and enemies
class Creature < GameObject
  def take_dmg(dmg)
    @health -= dmg
    @@objs << FloatingText.new(dmg.to_s, @x + @w / 2, @y)

    @@objs.delete(self) if @health <= 0
  end
end

# Represents a player square
class Player < Creature
  def initialize(x, y)
    @x = x
    @y = y
    @w = 64
    @h = 64
    @health = 100
    @solid = true
    @image = Gosu::Image.new('img/visored-helm.png')
  end

  def did_collide_with(obj)
    puts 'player collided'
    obj.take_dmg 50 if obj.is_a? Enemy
  end
end

# Represents an enemy
class Enemy < Creature
  def initialize(x, y)
    @x = x
    @y = y
    @w = 64
    @h = 64
    @health = 100
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
    @stamina -= 1 if did_move
  end
end
