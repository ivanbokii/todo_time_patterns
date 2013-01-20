require_relative 'lib/command_line'

pattern = ARGV[0]
command_line = CommandLine.new
result = command_line.parse pattern
p result