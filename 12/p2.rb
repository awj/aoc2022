#!/usr/bin/env ruby

class WorldMap
  attr_accessor :map, :start, :finish

  def initialize(input)
    @map = {}

    @start = nil
    @finish = nil
    @distances = {}

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

  def lowest_points
    map.keys.select do |k|
      map[k] == 0
    end
  end

  # This takes kind of a long time (~1 minute) for my actual input.
  #
  # It feels ... wrong. I think I could get more mileage out of reversing the
  # search. Start from the *finish* and "flood" out from there by creating new
  # paths in each viable direction until we find a zero-height location (because
  # we'd go breadth-first down the hills that first zero point would also be the
  # shortest path)
  def best_start
    lowest_points.map do |point|
      navigate(point, finish)
    # Some points have *no* valid path to the finish, for those we end up
    # returning nil and need to compact the results.
    end.compact.min_by(&:size)
  end

  # Yep, I was right, backtracking is *way* faster.
  def backtrack
    seen = Set.new([finish])

    paths = [ [finish] ]

    loop do
      puts paths.size

      path = paths.shift

      to_explore = step_down_from(path.last).reject do |location|
        seen.include?(location)
      end

      to_explore.each do |location|
        seen << location
        new_path = path + [location]
        if map[location] == 0
          return new_path
        else
          paths << new_path
        end
      end
    end
  end

  def navigate(from, dest)
    open_set = [from]

    gscore = Hash.new(Float::INFINITY)
    gscore[from] = 0

    came_from = {}

    fscore = Hash.new(Float::INFINITY)
    fscore[from] = dist(from, dest)

    until open_set.empty?
      current = open_set.min_by { |x| fscore[x] }

      return rebuild_path(came_from, current) if current == finish

      open_set.delete(current)

      accessible_from(current).each do |dir|
        # All *valid* moves have a weight of 1
        tentative_gscore = gscore[current] + 1
        if tentative_gscore < gscore[dir]
          came_from[dir] = current
          gscore[dir] = tentative_gscore
          fscore[dir] = tentative_gscore + dist(dir, dest)

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
  def dist(point, dest)
    @distances[[point, dest]] ||= begin
                                  ex, ey = dest
                                  px, py = point

                                  (px - ex).abs + (py - ey).abs
                                end
  end

  def step_down_from(location)
    row, col = location
    north = [row - 1, col]
    south = [row + 1, col]
    east = [row, col + 1]
    west = [row, col - 1]

    height = @map[location]

    [north, south, east, west].select do |dir|
      @map[dir] && (height - @map[dir]) <= 1
    end
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
