require_relative '../lib/todo_time_patterns'

pattern = ARGV[0]
result = TodoTimePatterns.parse pattern
puts result