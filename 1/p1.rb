#!/usr/bin/env ruby

def most_calories(input)
  # Split the input into "groups" by looking for \n\n in it, then summarize each
  # group and take the maximum.
  input.split(/\n\n/).map do |chunk|
    vals = chunk.split(/\n/).map(&:to_i)
    vals.sum
  end.max
end
