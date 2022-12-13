#!/usr/bin/env ruby

class Pair
  attr_reader :first, :second

  def self.parse(input)
    first, second = input.lines(chomp: true).map do |l|
      eval(l)
    end

    new(first, second)
  end

  def initialize(first, second)
    @first = first
    @second = second
  end

  def ordered?
    return @ordered if defined?(@ordered)

    puts "checking: #{first.inspect} vs #{second.inspect}"
    @ordered = run_comparisons(first, second) != :not_ordered
  end

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
      result = run_comparisons(Array(left), Array(right))
      return result unless result == :equal

      run_comparisons(first, second)
    elsif left.is_a?(Array)
      result = run_comparisons(left, right)
      return result unless result == :equal

      run_comparisons(first, second)
    elsif left == right
      run_comparisons(first, second)
    else
      left < right ? :ordered : :not_ordered
    end
  end
end
