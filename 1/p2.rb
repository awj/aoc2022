#!/usr/bin/env ruby

def most_calories(input, count)
  input.split(/\n\n/).map do |chunk|
    vals = chunk.split(/\n/).map(&:to_i)
    vals.sum
  end.max(count).sum
end
