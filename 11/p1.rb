#!/usr/bin/env ruby

class Monkey
  attr_accessor :count, :name, :items, :operation, :test, :if_true, :if_false, :monkeys
  def self.parse(input, monkeys)
    name, items, operation, test, if_true, if_false = input.lines(chomp: true)

    name = name.split(" ").last.to_i
    items = items.split(":").last.split(",").map(&:to_i)
    operation = if operation.include?("*")
                  if operation.include?("old * old")
                    ->(x) { x * x }
                  else
                    value = operation.split("*").last.to_i
                    ->(x) { x * value }
                  end
                else
                  value = operation.split("+").last.to_i
                  ->(x) { x + value }
                end
    test = test.split("divisible by").last.to_i
    if_true = if_true.split("monkey").last.to_i
    if_false = if_false.split("monkey").last.to_i

    monkeys << new(
      name: name,
      items: items,
      operation: operation,
      test: test,
      if_true: if_true,
      if_false: if_false,
      monkeys: monkeys
    )
  end

  def initialize(name:, items:, operation:, test:, if_true:, if_false:, monkeys:)
    @name = name
    @items = items
    @operation = operation
    @test = test
    @if_true = if_true
    @if_false = if_false
    @monkeys = monkeys
    @count = 0
  end

  def run_inspections
    puts "monkey: #{name}"
    while (item = items.shift)
      puts "starting worry level: #{item}"
      item = operation.call(item)
      puts "new worry level: #{item}"
      item = (item.to_f / 3.0).floor
      puts "calm down to worry level: #{item}"

      @count += 1

      puts "checking #{item} % #{test} (#{item % test})== 0"
      if item % test == 0
        puts "pass: throwing #{item} to #{if_true}"
        monkeys[if_true].items << item
      else
        puts "fail: throwing #{item} to #{if_false}"
        monkeys[if_false].items << item
      end
    end
  end
end

def run(text, rounds: 20)
  monkey_descriptions = text.split("\n\n")
  monkeys = []

  monkey_descriptions.each do |description|
    Monkey.parse(description, monkeys)
  end

  rounds.times do
    monkeys.each(&:run_inspections)
  end

  monkeys
end
