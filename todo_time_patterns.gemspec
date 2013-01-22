require 'rake'

Gem::Specification.new do |s|
  s.name        = 'todo_time_patterns'
  s.version     = '0.0.0'
  s.summary     = "Library that helps you to parse date patterns in strings like 'meet Bob at 5:45pm'"
  s.description =  <<-EOF
    Todo time patterns is a small library that helps you to parse different
    time patterns in strings like:
      - meet bob at 4pm
      - meeting at 13:34
      - watch Adventure Times at 3:34pm
      - Go shopping at 2pm for 2h
      - Pay your tech. debt at 2pm for 35mins to Mafia
      - Sleep well from 1am to 8:00

      etc.
  EOF
  s.authors     = ["Ivan Bokii"]
  s.email       = 'bokiyis@gmail.com'
  s.files       = FileList["lib/**/*.rb", "tests/*.rb"]
  s.homepage    = 'https://github.com/spkenny/todo_time_patterns'
end