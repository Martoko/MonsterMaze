require 'gosu'
require_relative 'game_object'
require_relative 'creature'
require_relative 'background'
require_relative 'floating_text'
require_relative 'endgame_text'
require_relative 'instructions_overlay'
require 'pry'

# IDEA: Sight/visbility like in ADOM
# IDEA: Sight/visibility determined by perception
# IDEA: Speed determines how likely it is that enemies get a tick
# IDEA: Attack by "nudging" the enemy, e.g. trying to occupy the space
#       With small healthbars underneath both the player and the enemies
# IDEA: Visualise the entire A* proccess,
#       with space acting as the next step button

# Represents a tile object, holding basic things like x, y, w, h, static
class Tile < GameObject
  attr_reader :type
  def initialize(x, y, type = :air)
    @x = x
    @y = y
    @z = 0
    @w = 64
    @h = 64
    @solid = true
    @solid = false if type == :air
    @type = type
  end

  def draw
    z = 0
    color = Gosu::Color.new(255, 220, 220, 220) if @type == :air
    color = Gosu::Color.new(255, 40, 40, 40) if @type == :wall
    Gosu.draw_rect(@x, @y, @w, @h, color, z)
  end
end

Map = [[:W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W],
       [:W, :O, :W, :_, :_, :_, :_, :_, :_, :_, :W, :_, :_, :O, :W],
       [:W, :_, :W, :_, :_, :_, :W, :_, :_, :_, :W, :_, :_, :_, :W],
       [:W, :_, :W, :_, :_, :_, :W, :_, :_, :_, :_, :_, :_, :W, :W],
       [:W, :_, :W, :_, :_, :_, :W, :_, :_, :_, :W, :_, :_, :_, :W],
       [:W, :_, :W, :_, :W, :W, :W, :W, :W, :_, :W, :W, :_, :_, :W],
       [:W, :_, :_, :P, :_, :_, :_, :_, :_, :_, :W, :W, :W, :_, :W],
       [:W, :_, :W, :W, :W, :W, :_, :W, :W, :_, :W, :_, :_, :_, :W],
       [:W, :_, :_, :_, :_, :_, :_, :_, :_, :_, :W, :_, :W, :W, :W],
       [:W, :_, :_, :_, :_, :_, :W, :_, :W, :W, :W, :_, :_, :O, :W],
       [:W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W, :W]].freeze
def gen_tiles
  tiles = []
  Map.each_with_index do |row, y|
    row.each_with_index do |type_id, x|
      type = :air if type_id == :P || type_id == :O
      type = :air if type_id == :_
      type = :wall if type_id == :W
      tiles << Tile.new(5 + x * (64 + 5), 5 + y * (64 + 5), type)
    end
  end
  tiles
end

def gen_player
  Map.each_with_index do |row, y|
    row.each_with_index do |type_id, x|
      return Player.new(5 + x * (64 + 5), 5 + y * (64 + 5)) if type_id == :P
    end
  end
end

def gen_enemies
  enemies = []
  Map.each_with_index do |row, y|
    row.each_with_index do |type_id, x|
      next unless type_id == :O
      _type = :orc if type_id == :O
      enemies << Enemy.new(5 + x * (64 + 5), 5 + y * (64 + 5))
    end
  end
  enemies
end

# A node holding a physical position, neighbours, and a cost
class Node
  attr_reader :tile, :x, :y, :parent
  attr_accessor :prev_cost, :own_cost, :total_cost
  def initialize(tile, parent: nil, start_node: nil)
    @tile = tile
    @x = tile.x
    @y = tile.y
    @parent = parent

    @total_cost = 0
    return unless parent
    @prev_cost = parent.total_cost + dist_between(parent)
    @own_cost = dist_between(start_node)
    @total_cost = @prev_cost + @own_cost
  end

  def dist_between(other_node)
    dx = (@x - other_node.x).abs
    dy = (@y - other_node.y).abs
    dx**2 + dy**2
  end
end

# Hosts the top level window.
class GameWindow < Gosu::Window
  def initialize(v_tiles = 15, h_tiles = 11)
    @w = 5 + (69 * v_tiles)
    @h = 5 + (69 * h_tiles)
    super @w, @h
    self.caption = 'Monster Maze'
    @player = gen_player
    bg = Background.new(@w, @h)
    @tiles = gen_tiles
    @instruct_overlay = InstructionsOverlay.new(self)
    @objs = [bg, @player, @instruct_overlay] + @tiles + gen_enemies
    GameObject.set_objects @objs

    @paused = true
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    close if id == Gosu::KbEscape

    if @paused
      initialize unless @objs.include? @instruct_overlay
      @objs.delete @instruct_overlay if @objs.include? @instruct_overlay
      @paused = false
      return
    end

    move_player(0, 1) if id == Gosu::KbDown
    move_player(0, -1) if id == Gosu::KbUp
    move_player(1, 0) if id == Gosu::KbRight
    move_player(-1, 0) if id == Gosu::KbLeft
    move_player(0, 0) if id == Gosu::KbSpace
  end

  def move_player(ver_sq, hor_sq)
    new_x = @player.x + ver_sq * (@player.w + 5)
    new_y = @player.y + hor_sq * (@player.h + 5)

    player_did_move = @player.try_move(new_x, new_y)

    if player_did_move
      move_enemies
      @objs.each do |obj|
        obj.passive_heal if obj.respond_to? :passive_heal
      end
    end

    if @player.health <= 0
      @objs << EndgameText.new(self, :lose)
      @paused = true
    end

    won = true
    @objs.each do |obj|
      won = false if obj.is_a? Enemy
    end
    if won
      @objs << EndgameText.new(self, :win)
      @paused = true
    end

  end

  def move_enemies
    enemies = @objs.find_all { |obj| obj.is_a? Enemy }
    enemies.each { |enemy| move_enemy(enemy) }
  end

  def move_enemy(enemy)
    return if enemy.x == @player.x && enemy.y == @player.y
    movement_path = a_star([enemy.x, enemy.y], [@player.x, @player.y])
    return unless movement_path # No solution found
    return if movement_path.length > 7 # not close enough to 'spot' the player
    new_x = movement_path[1][0]
    new_y = movement_path[1][1]
    enemy.try_move(new_x, new_y)
  end

  def unwrap_movement_path(movement_path)
    cur_node = movement_path
    flat_path = []
    while cur_node
      x = cur_node.x
      y = cur_node.y
      flat_path.push [x, y]
      cur_node = cur_node.parent
    end
    flat_path.reverse
  end

  def a_star(start_pos, end_pos)
    start_node = nil
    @tiles.each do |tile|
      start_node = Node.new(tile) if tile.x == start_pos[0] && tile.y == start_pos[1]
    end

    open_nodes = [start_node]
    closed_nodes = []

    until open_nodes.empty?
      open_nodes.sort! do |a, b|
        b.total_cost <=> a.total_cost
      end
      current_node = open_nodes.pop

      find_tile_neighbours(current_node.tile).each do |neighbour|
        next if neighbour.type == :wall

        if neighbour.x == end_pos[0] && neighbour.y == end_pos[1]
          movement_path = Node.new(neighbour, parent: current_node, start_node: start_node)
          return unwrap_movement_path(movement_path)
        end

        should_add = true
        open_nodes.each do |open_node|
          should_add = false if open_node.x == neighbour.x && open_node.y == neighbour.y
        end
        closed_nodes.each do |closed_node|
          should_add = false if closed_node.x == neighbour.x && closed_node.y == neighbour.y
        end


        open_nodes << Node.new(neighbour, parent: current_node, start_node: start_node) if should_add
      end

      closed_nodes << current_node
    end

    return nil
  end

  def find_tile_neighbours(tile)
    neighbours = []
    @tiles.each do |other_tile|
      next if tile.y == other_tile.y && tile.x == other_tile.x
      if ((tile.x - other_tile.x).abs == 69 && (tile.y - other_tile.y).abs == 0) ||
         ((tile.x - other_tile.x).abs == 0 && (tile.y - other_tile.y).abs == 69)
        neighbours.push other_tile
      end
    end
    neighbours
  end

  def update
    @objs.each { |obj| obj.update if obj.respond_to? :update }
  end

  def draw
    @objs.each { |obj| obj.draw if obj.respond_to? :draw }
  end
end
