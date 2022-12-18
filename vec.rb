#!/usr/bin/env ruby

class Vec
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(vec)
    Vec.new(
      x + vec.x,
      y + vec.y
    )
  end

  def -(vec)
    Vec.new(
      x - vec.x,
      y - vec.y
    )
  end

  def dup
    Vec.new(x, y)
  end

  def delta(x, y)
    Vec.new(self.x + x, self.y + y)
  end

  def eql?(other)
    return false unless other.class == Vec

    other.x == self.x && other.y == self.y
  end

  def hash
    @hash ||= [x, y].hash
  end

  def to_s
    inspect
  end

  def spread_x(dist)
    (-dist..dist).map do |i|
      delta(i, 0)
    end
  end

  def closer_points(other)
    dist = manhattan(other)

    dist.times.map do |i|
      d = i + 1

      points = []

      n = delta(0, -d)
      s = delta(0, d)
      e = delta(d, 0)
      w = delta(-d, 0)

      points += [n, s, e, w]

      i.times do
        points << (n = n.delta(1, 1))
        points << (e = e.delta(-1, 1))
        points << (s = s.delta(-1, -1))
        points << (w = w.delta(1, -1))
      end

      points
    end.flatten
  end

  def inspect
    "(#{x}, #{y})"
  end

  def along(x: nil, y: nil)
    Vec.new(
      x || self.x,
      y || self.y
    )
  end

  def manhattan(vec)
    (x - vec.x).abs + (y - vec.y).abs
  end
end
