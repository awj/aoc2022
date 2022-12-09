#!/usr/bin/env ruby

require "matrix"

class Grid
  attr_accessor :grid, :cols, :rows

  def self.build(input_string)
    grid = input_string.lines(chomp: true).map do |line|
      line.chars.map(&:to_i)
    end

    new(grid)
  end

  def initialize(grid)
    @grid = Matrix[*annotate(grid)]
    @rows = grid.size
    @cols = grid.first.size
  end

  def find_visible
    s = Set.new

    grid.row_vectors.each do |row|
      s += visible_locations(row)
      s += visible_locations(row.reverse_each)
    end

    grid.column_vectors.each do |column|
      s += visible_locations(column)
      s += visible_locations(column.reverse_each)
    end

    s
  end

  private

  def visible_locations(values)
    highest_seen = -1
    values.filter_map do |value|
      location, height = value

      if height > highest_seen
        highest_seen = height
        location
      end
    end
  end

  def annotate(grid_arrays)
    grid_arrays.each_with_index.map do |row, row_number|
      row.each_with_index.map do |value, col_number|
        [[row_number, col_number], value]
      end
    end
  end
end
