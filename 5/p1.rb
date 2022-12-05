#!/usr/bin/env ruby

class CrateStack
  attr_accessor :number, :crates

  def initialize(number, crates = [])
    @number = number
    @crates = crates
  end

  def push(items)
    @crates.push(*Array(items))
  end

  def pop(count)
    Array(@crates.pop(count))
  end

  def top
    @crates.last
  end
end

def instruction(line)
  parts = line.split(" ")
  count = parts[1]
  source = parts[3]
  dest = parts[5]

  [
    count.to_i,
    source.to_i,
    dest.to_i
  ]
end

class Yard
  attr_accessor :stacks

  def initialize(stacks)
    @order = stacks.map(&:number)
    @stacks = stacks.to_h do |stack|
      [stack.number, stack]
    end
  end

  def process(instruction)
    count, source, dest = instruction

    taken_off = stacks[source].pop(count)

    taken_off.reverse.each do |crate|
      stacks[dest].push(crate)
    end
  end

  def tops
    @order.map do |number|
      stacks[number].top
    end
  end
end

y = Yard.new(
  [
    CrateStack.new(1, "LNWTD".chars),
    CrateStack.new(2, "CPH".chars),
    CrateStack.new(3, "WPHNDGMJ".chars),
    CrateStack.new(4, "CWSNTQL".chars),
    CrateStack.new(5, "PHCN".chars),
    CrateStack.new(6, "THNDMWQB".chars),
    CrateStack.new(7, "MBRJGSL".chars),
    CrateStack.new(8, "ZNWGVBRT".chars),
    CrateStack.new(9, "WGDNPL".chars)
  ]
)
