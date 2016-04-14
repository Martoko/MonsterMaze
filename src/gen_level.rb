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
