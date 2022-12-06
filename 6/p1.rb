#!/usr/bin/env ruby

def find_marker(input_string)
  count = 4 # start at 3, since we need at least that many characters to begin
            # evaluations
  input_string.chars.each_cons(4) do |group|
    if group.uniq.size == 4
      break
    else
      count += 1
    end
  end

  count
end
