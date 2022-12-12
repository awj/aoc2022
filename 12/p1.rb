#!/usr/bin/env ruby

class WorldMap
  attr_accessor :map, :start, :finish

  def initialize(input)
    @map = {}

    @start = nil
    @finish = nil

    input.lines(chomp: true).each_with_index do |row, row_number|
      row.chars.each_with_index do |val, col_number|
        height = val.bytes.first - 97
        if val == "S"
          @start = [row_number, col_number]
          height = 0
        elsif val == "E"
          @finish = [row_number, col_number]
          height = 25
        end

        @map[[row_number, col_number]] = height
      end
    end
  end

  def navigate
    open_set = [start]

    gscore = Hash.new(Float::INFINITY)
    gscore[start] = 0

    came_from = {}

    fscore = Hash.new(Float::INFINITY)
    fscore[start] = dist(start)

    until open_set.empty?
      current = open_set.min_by { |x| fscore[x] }

      puts "current: #{current}"

      return rebuild_path(came_from, current) if current == finish

      open_set.delete(current)

      accessible_from(current).each do |dir|
        # All *valid* moves have a weight of 1
        tentative_gscore = gscore[current] + 1
        if tentative_gscore < gscore[dir]
          came_from[dir] = current
          gscore[dir] = tentative_gscore
          fscore[dir] = tentative_gscore + dist(dir)

          open_set << dir unless open_set.include?(dir)
        end
      end
    end
  end

  def rebuild_path(history, current)
    path = [current]

    while history.keys.include?(current)
      current = history[current]
      path.unshift(current)
    end

    path
  end

  # Use manhattan distance as our heuristic?
  def dist(point)
    ex, ey = finish
    px, py = point

    (px - ex).abs + (py - ey).abs
  end

  def accessible_from(location)
    row, col = location
    north = [row - 1, col]
    south = [row + 1, col]
    east = [row, col + 1]
    west = [row, col - 1]

    height = @map[location]

    [north, south, east, west].select do |dir|
      @map[dir] && @map[dir] <= height + 1
    end
  end
end
