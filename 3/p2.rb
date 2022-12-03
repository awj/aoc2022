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

# Assuming that each "group" is a set of three already-prioritized rucksacks (no
# need to split into pouches), we can identify the once priority they all
# contain by intersecting all three arrays. Per definition there is only one
# common element in all three.
def badge(group)
  group.reduce(&:&).first
end

# Turn each rucksack into a priority list, then generate groups via
# `each_slice(3)` so we can find the badge in common for that group.
def sum_of_badges(rucksacks)
  rucksacks.lazy.map do |rucksack|
    prioritize(rucksack)
  end.each_slice(3).sum do |group|
    badge(group)
  end
end
