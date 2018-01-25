#!/usr/bin/ruby

lines = []
ARGF.each{|line|
  lines.push(line)
  cmd = line.split(']')[1]
  if cmd.chomp == ' exit'
    lines.clear
  end
}
puts lines
