#!/usr/bin/env ruby

# Each knot is linked to the next knot in a chain and either:
# * is moved directly (because it's the head)
# * "follows" some target location (based on the knot ahead of it)
#
# Call `#move` on the "head" knot, and subsequent ones will follow when they are
# getting too far away.
#
# Every knot keeps a Set of seen locations that gives a unique history of that
# knot's positions.
class Knot
  attr_accessor :location, :seen, :follower

  def initialize(follower = nil)
    @location = [0, 0]
    @seen = Set.new([location])
    @follower = follower
  end

  def move(adjustment)
    row, col = location
    dx, dy = adjustment

    @location = [row + dx, col + dy]
    follower&.follow(location)
  end

  def follow(target)
    return unless should_follow?(target)

    trow, tcol = target
    lrow, lcol = location

    # Spaceship operator reminder: LEFT <=> RIGHT, what should we do to RIGHT to
    # move it closer to LEFT
    dx = trow <=> lrow
    dy = tcol <=> lcol

    @location = [lrow + dx, lcol + dy]

    follower&.follow(location)

    seen << location
  end

  def should_follow?(target)
    frow, fcol = target
    row, col = location

    (frow - row).abs > 1 || (fcol - col).abs > 1
  end
end

# Simulate movement of a rope of N-knots based on incremental position
# adjustments of the head.
#
# #simulate does almost all the work here by:
# * telling the head knot to move based on the adjustment
# * returning the seen positions of the *last* knot in the chain
class Simulation
  attr_accessor :head, :knots

  # Turn a list of adjustments into a (bigger) list of the incremental steps.
  # Example:
  # "R 3" => [ [0, 1], [0, 1], [0, 1] ]
  #
  # The final list is flattened into one long sequence of steps, for ease of
  # use.
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

  def initialize(num_knots)
    prev = nil
    @knots = num_knots.times.map do
      prev = Knot.new(prev)
    end.reverse
    @head = knots.first
  end

  def simulate(instructions)
    instructions.each do |adjustment|
      head.move(adjustment)
    end

    knots.last.seen
  end
end
