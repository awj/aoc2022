#!/usr/bin/env ruby

class Simulation
  attr_accessor :head, :tail

  def self.build_adjustments(instructions)
    instructions.flat_map do |instruction|
      dir, amount = instruction.split(" ")
      amount = amount.to_i

      amount.times.map do
        case dir
        when "R" then [0, 1]
        when "L" then [0, -1]
        when "U" then [1, 0]
        when "D" then [-1, 0]
        end
      end
    end
  end

  def initialize
    @head = [0, 0]
    @tail = [0, 0]
  end

  def move_tail
    hrow, hcol = head
    trow, tcol = tail

    dx = hrow <=> trow
    dy = hcol <=> tcol

  @tail = [trow + dx, tcol + dy]
  end

  def move_head(adjustment)
    dx, dy = adjustment
    hrow, hcol = head

    @head = [hrow + dx, hcol + dy]
  end

  def move_tail?
    hrow, hcol = head
    trow, tcol = tail

    (hrow - trow).abs > 1 || (hcol - tcol).abs > 1
  end

  def simulate(instructions)
    seen_locations = Set.new

    instructions.each do |adjustment|
      move_head(adjustment)
      move_tail if move_tail?
      seen_locations << tail
    end

    seen_locations
  end
end
