#!/usr/bin/env ruby

class Instruction
  attr_accessor :delay, :instruction

  def self.parse(input)
    inst, val = input.split

    case inst
    when "noop" then new(inst, 1, ->(m){})
    when "addx" then new(inst, 2, ->(m){ m.register += val.to_i })
    else
      raise "unknown instruction '#{inst}'"
    end
  end

  def initialize(name, delay, action)
    @name = name
    @delay = delay
    @action = action
  end

  def tick(machine)
    @delay -= 1

    @action.call(machine) if @delay == 0
  end

  def finished?
    delay <= 0
  end
end

class Machine
  attr_accessor :cycles, :register, :samples, :instructions, :debug

  def self.for(instruction_text)
    new(
      instruction_text.lines(chomp: true).map do |line|
        Instruction.parse(line)
      end
    )
  end

  def initialize(instructions)
    @cycles = 0
    @register = 1
    @samples = []
    @instructions = instructions
    @current_instruction = instructions.shift
    @debug = []
  end

  def run
    loop do
      if @current_instruction.finished?
        @current_instruction = @instructions.shift
        return if @current_instruction.nil?
      end

      @cycles += 1
      @samples << (register * cycles) if should_sample?

      @current_instruction.tick(self)
      @debug << [cycles, register]
    end
  end

  def should_sample?
    return false if cycles > 220

    (cycles - 20) % 40 == 0
  end
end
