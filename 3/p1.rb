#!/usr/bin/env ruby

PRIORITIES = {}

# Since it's all ascii characters, and 'a' starts at byte 97, we can subtract
# 96 from the bytes to convert to priority lists.
('a'..'z').each do |char|
  priority = char.bytes.first - 96
  PRIORITIES[char] = priority
end

# Since it's all ascii characters, and 'A' starts at byte 39, we can subtract
# 38 from the bytes to convert to priority lists.
('A'..'Z').each do |char|
  priority = char.bytes.first - 38
  PRIORITIES[char] = priority
end

def prioritize(rucksack)
  rucksack.chars.map { |b| PRIORITIES[b] }
end

def parts(rucksack)
  # Assume we always have equal-length rucksacks?
  size = rucksack.size / 2

  [
    rucksack[0..(size-1)],
    rucksack[size..-1]
  ]
end

def duplicate(rucksack)
  parts(prioritize(rucksack)).reduce(&:&).first
end

def sum_of_duplicates(rucksacks)
  rucksacks.sum do |rucksack|
    duplicate(rucksack)
  end
end
