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
end
