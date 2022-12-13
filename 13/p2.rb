#!/usr/bin/env ruby

class Packet
  attr_reader :data

  include Comparable

  def self.parse(input)
    new(eval(input))
  end

  def initialize(data)
    @data = data
  end

  def ==(other)
    data == other.data
  end

  def <=>(other)
    case run_comparisons(data.dup, other.data.dup)
    when :ordered then -1
    when :equal then 0
    when :not_ordered then 1
    end
  end

  private

  def run_comparisons(first, second)
    left = first.shift
    right = second.shift

    # If the left side ran out of items first, we're in order
    return :ordered if !left && right
    # If the right side ran out of items first, we're out of order
    return :not_ordered if left && !right

    # If we ran out of items to compare, we're equal
    return :equal if !left && !right

    # If we've got mixed results, wrap whichever one isn't an Array in an Array
    # and run comparisons, then proceed with the next thing if that comparison
    # succeeds.
    if left.class != right.class
      result = run_comparisons(Array(left.dup), Array(right.dup))
      return result unless result == :equal

      run_comparisons(first.dup, second.dup)
    elsif left.is_a?(Array)
      result = run_comparisons(left.dup, right.dup)
      return result unless result == :equal

      run_comparisons(first.dup, second.dup)
    elsif left == right
      run_comparisons(first.dup, second.dup)
    else
      left < right ? :ordered : :not_ordered
    end
  end
end
