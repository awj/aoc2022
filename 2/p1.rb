#!/usr/bin/env ruby

ROCK = 1
PAPER = 2
SCISSORS = 3

WIN = 6
LOSS = 0
TIE = 3
# Reminders:
# A,B,C - their choice (rock, paper, scissors)
# X,Y,Z - your choice (rock, paper, scissors)
#
# Scoring:
# Your choices are always worth (1, 2, 3)
# Win: 6 points
# Lose: 0 points
# Tie: 3 points
#
# Score is choice + result
RESULTS = {
  "A X" => ROCK + TIE,
  "B X" => ROCK + LOSS,
  "C X" => ROCK + WIN,
  "A Y" => PAPER + WIN,
  "B Y" => PAPER + TIE,
  "C Y" => PAPER + LOSS,
  "A Z" => SCISSORS + LOSS,
  "B Z" => SCISSORS + WIN,
  "C Z" => SCISSORS + TIE
}

def result(input)
  input.lines(chomp: true).sum(0) do |round|
    RESULTS.fetch(round)
  end
end
