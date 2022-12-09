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

  def scenic_score(location)
    row, col = location

    return 0 if row == 0 || col == 0 || row == rows || col == cols

    height = grid[*location][1]

    locations = [
      (row-1).downto(0).map { |r| [r, col] },
      (row+1).upto(rows - 1).map { |r| [r, col] },
      (col-1).downto(0).map { |c| [row, c] },
      (col+1).upto(cols - 1).map { |c| [row, c] }
    ]

    visibilities = locations.map do |list|
      visibile_along(list, height)
    end

    visibilities.reduce(:*)
  end

  def visibile_along(path, height)
    seen = path.take_while do |location|
      grid[*location][1] < height
    end

    return path.size if seen.size == path.size

    seen.size + 1
  end

  private

  def annotate(grid_arrays)
    grid_arrays.each_with_index.map do |row, row_number|
      row.each_with_index.map do |value, col_number|
        [[row_number, col_number], value]
      end
    end
  end
end
