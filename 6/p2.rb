#!/usr/bin/env ruby

def find_marker(input_string, group_size)
  count = group_size # start at `group_size`, since we need at least that many
                     # characters to begin evaluations
  input_string.chars.each_cons(group_size) do |group|
    if group.uniq.size == group_size
      break
    else
      count += 1
    end
  end

  count
end
