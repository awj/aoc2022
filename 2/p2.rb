#!/usr/bin/env ruby

ROCK = 1
PAPER = 2
SCISSORS = 3

WIN = 6
LOSS = 0
TIE = 3
# Reminders:
# A,B,C - their choice (rock, paper, scissors)
# X,Y,Z - your choice (lose, tie, win)
#
# Scoring:
# Your choices are always worth (1, 2, 3)
# Win: 6 points
# Lose: 0 points
# Tie: 3 points
#
# Score is choice + result
RESULTS = {
  "A X" => LOSS + SCISSORS,
  "B X" => LOSS + ROCK,
  "C X" => LOSS + PAPER,
  "A Y" => TIE + ROCK,
  "B Y" => TIE + PAPER,
  "C Y" => TIE + SCISSORS,
  "A Z" => WIN + PAPER,
  "B Z" => WIN + SCISSORS,
  "C Z" => WIN + ROCK
}

def result(input)
  input.lines(chomp: true).sum(0) do |round|
    RESULTS.fetch(round)
  end
end
