#!/usr/bin/env ruby
#
load "../vec.rb"

class Map
  attr_accessor :max, :sensor_distances, :max_x, :max_y, :map, :min_x, :min_y

  def initialize(description)
    @map = Hash.new
    @sensor_distances = Hash.new
    parse(description)
  end

  def extract(y)
    seen = Set.new
    sensor_distances.each do |s, d|
      intersection = s.along(y: y)
      dist_to_intersection = s.manhattan(intersection)
      next if d < dist_to_intersection

      diff = d - dist_to_intersection

      intersection.spread_x(diff).each do |pt|
        seen << pt unless @map[pt] == "B"
      end
    end

    seen
  end

  def no_beacons(line)
    extract(line).compact.count { |filled| filled != "B" }
  end

  def parse(description)
    scan = /Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)/
    description.lines(chomp: true).each do |line|
      sx, sy, bx, by = line.scan(scan).first.map(&:to_i)
      sensor = Vec.new(sx, sy)
      beacon = Vec.new(bx, by)

      @map[sensor] = "S"
      @map[beacon] = "B"

      @sensor_distances[sensor] = sensor.manhattan(beacon)
    end
  end

  def fill_line(point, distance)
    distance.times.map do |i|
      d = i + 1
      @map[point.delta(-d, 0)] ||= "#"
      @map[point.delta(d, 0)] ||= "#"
    end
  end
end
