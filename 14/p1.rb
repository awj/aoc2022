#!/usr/bin/env ruby

class Map
  attr_accessor :map, :lowest_y

  def initialize(rocks)
    @map = {}
    @lowest_y = 0
    parse(rocks)
  end

  def parse(rocks)
    rocks.lines(chomp: true).each do |description|
      segments = description.split(" -> ")
      segments.each_cons(2) do |line|
        path(line).each do |location|
          _x, y = location
          @lowest_y = [@lowest_y, y].max
          map[location] = "#"
        end
      end
    end
  end

  def fill(spigot)
    count = 0
    loop do
      s = Sand.new(spigot, self, count)

      if s.settle! == :below_map
        break
      else
        map[s.location] = 'o'
        count += 1
      end
    end

    count
  end

  def [](location)
    @map[location]
  end

  def path(line)
    start, finish = line
    x1,y1 = start.split(",").map(&:to_i)
    x2, y2 = finish.split(",").map(&:to_i)

    if x1 == x2
      if y1 < y2
        (y1..y2).map { |y| [x1, y] }
      else
        (y2..y1).map { |y| [x1, y] }
      end
    else
      if x1 < x2
        (x1..x2).map { |x| [x, y1] }
      else
        (x2..x1).map { |x| [x, y1] }
      end
    end
  end
end

class Sand
  attr_accessor :x, :y, :map, :id

  def initialize(location, map, id)
    @x = location[0]
    @y = location[1]
    @map = map
    @id = id
  end

  def location
    [x, y]
  end

  def settle!
    loop do
      break :below_map if below_map?

      if map[down].nil?
        move(down)
      elsif map[down_left].nil?
        move(down_left)
      elsif map[down_right].nil?
        move(down_right)
      else
        break :settled
      end
    end
  end

  def below_map?
    y > map.lowest_y
  end

  private

  def down
    [x, y + 1]
  end

  def move(location)
    old = [x, y]
    self.x, self.y = location
    puts "#{id}: #{old} -> #{location}"
  end

  def down_left
    [x - 1, y + 1]
  end

  def down_right
    [x + 1, y + 1]
  end
end
