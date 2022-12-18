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

  # The search space in the problem is HUGE.
  #
  # The key bit here is that the only viable point is going to meet two criteria:
  # * it's within the search area
  # * it's *just outside* the range of at least one sensor
  #
  # If it were further than "just outside" of *all* of the sensors, we'd have
  # more than one point that's a viable answer, which we know isn't true from
  # the problem definition.
  #
  # So the solution here goes:
  # * walk through each sensor
  # * get a list of the points that are *just outside* of that sensor
  # * return the point if it is beyond *all* of the sensors
  def locate(max_distance)
    sensor_distances.each do |sensor, d|
      sensor.just_beyond(d).each do |pt|
        next if pt.x < 0 || pt.x > max_distance
        next if pt.y < 0 || pt.y > max_distance

        return pt if outside_sensors(pt)
      end
    end
  end

  def outside_sensors(point)
    sensor_distances.all? do |sensor, d|
      sensor.manhattan(point) > d
    end
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
