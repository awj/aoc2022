#!/usr/bin/env ruby

class DirTree
  def initialize(name)
    @name = name
    @directories = {}
    @local_size = 0
  end

  def stat(input)
    input.each do |l|
      if l.start_with?("dir")
        subdir = l.split(" ", 2).last
        @directories[subdir] = DirTree.new(subdir)
      else
        @local_size += l.split(" ").first.to_i
      end
    end
  end

  def list
    @directories.values.reduce([self]) do |all_dirs, current|
      all_dirs.chain(current.list)
    end
  end

  def size
    @local_size + @directories.values.sum(&:size)
  end

  def cd(name)
    @directories.fetch(name)
  end
end

def parse(raw_input)
  # Break input lines into chunks every time we see a new '$', so that way the
  # command and output are combined.
  raw_input.lines(chomp: true).chunk_while do |_l1, l2|
    !l2.start_with?("$")
  end
end

class Machine
  attr_accessor :root, :current

  def initialize
    @root = ::DirTree.new("/")
    @current = @root
    @history = []
  end

  def process(instruction)
    command = instruction.first

    # Get everything after the $
    operations = command.split(" ").drop(1)

    case operations
        in ["cd", "/"]
        @current = @root
        @history = []
        in ["cd", ".."]
        @current = @history.pop
        in ["cd", target]
        @history << @current
        @current = @current.cd(target)
        in ["ls"]
        @current.stat(instruction.drop(1))
    end
  end
end
