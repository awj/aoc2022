#!/usr/bin/env ruby

# The Range type is perfect for expressing this.
def extract_range(text)
  first, last = text.split("-").map(&:to_i)
  first..last
end

def process(input)
  input.lines.map do |line|
    first_elf, second_elf = line.split(",")

    [
      extract_range(first_elf),
      extract_range(second_elf)
    ]
  end
end

# Weirdly, the Range type *doesn't* have a method to see if it intersects
# another range. But ... Set does against another Set, so let's cheat via
# `Enumerable#to_set`
#
# Ironically, Elixir has that, (via inverting `Range.disjoin?`) but doesn't have
# a "does this range fully contain this other range"
def any_overlaps(input)
  input.select do |pair|
    pair.map(&:to_set).reduce(&:intersect?)
  end
end
