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

    @lowest_y = lowest_y + 1
  end

  def fill(spigot)
    marker = 'o'
    count = 0
    s = Sand.new(spigot.dup, self, count)
    loop do
      s.location = spigot.dup
      s.id = count

      s.settle!
      count += 1
      map[s.location] = marker

      break if map[spigot]
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
  attr_accessor :location, :map, :id

  def initialize(location, map, id)
    @location = location
    @map = map
    @id = id
  end

  def settle!
    loop do
      break :settled if location[1] == map.lowest_y

      location[1] = location[1] + 1
      next if map[location].nil?

      location[0] = location[0] - 1
      next if map[location].nil?

      location[0] = location[0] + 2
      next if map[location].nil?

      location[0] -= 1
      location[1] -= 1

      break :settled
    end
  rescue IRB::Abort
    puts "#{id}: #{location}"
    raise
  end
end
