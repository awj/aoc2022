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

def full_overlaps(input)
  input.select do |pair|
    first_elf, second_elf = pair

    first_elf.cover?(second_elf) || second_elf.cover?(first_elf)
  end
end
