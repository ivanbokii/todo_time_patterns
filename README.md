Todo time patterns
=========

Small library that helps you parse a string and get information
about time patterns in it.

It parses next patterns:

  * Meeting at 11:00
  * Meeting at 11am
  * Party at 11:45pm
  * Meet Bob at 11:00 for 30m to discuss the project
  * Meet James at 11:00 for 1h
  * Watch Adventure Time from 11:00 to 11pm to stay ~CRAZY~

it supports modifiers for minutes and hours like:

  * m, min, mins, minutes
  * h, hour, hours
  
it recognizes time patterns ({time}) as:

  * 11:00
  * 11am/pm
  * 3:45pm
 
and uses those patterns to recognize intervals like:

  * at {time} for {interval}
  * from {time} to {time}
 
where {interval} can be "30 minutes" or "1 hour" or "1 hour 34min.

How to use
-

```ruby
require "todo_time_patterns"

input = "meet Bob at 4pm for 2 hours 30min"
p TodoTimePatterns.parse input

#prints {:hours=>16, :minutes=>0, :interval=>150, :result_string=>"meet Bob"} on screen

#-------

input = "meet Bob at 16:34"
p TodoTimePatterns.parse input

#prints {:hours=>16, :minutes=>34, :interval=>0, :result_string=>"meet Bob"}

```

Setup
-
```ruby
gem install 'todo_time_patterns'
```

    
