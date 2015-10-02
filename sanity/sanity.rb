#!/usr/bin/env ruby
#
# - sanity.rb
#
# swap put argv for optparse
# add in better error checking and a usage
#
#
##################################################################

# How may times should it loop ?
repeat = ARGV[0]
if repeat.nil?
  repeat = 2
else
  repeat = repeat.to_i
end

# Pick a random number to see how often you want to introduce typoes.
# Lower numbers will generate a higher number of errors.
randomizer = ARGV[1]
if randomizer.nil?
  randomizer = 10
else
  randomizer = randomizer.to_i
end

message = [ 'A','l','l',' ',
'w','o','r','k',' ',
'a','n','d',' ',
'n','o',' ',
'p','l','a','y',' ',
'm','a','k','e','s',' ',
'J','a','c','k',' ',
'a',' ',
'd','u','l','l',' ',
'b','o','y','.',' '
]

def even_odd(letter)
  # Decide if a number is even or odd and change case based on it.
  number = rand(2)
    if number.even?
      @letter = letter.upcase
    else
      @letter = letter
    end
end

def random_char()
  # Find a random letter in the alphabet when triggered.
  alpha = 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
  new_char = alpha[rand(25)]
  even_odd(new_char)
end

def check_the_facts(repeat, randomizer)
  # Make sure that the values are what we think then are.
  things = {}
  things[:repeat] = repeat
  things[:randomizer] = randomizer

  things.each do |x,y|
    unless y.is_a? Integer
      puts "#{x} must be an Integer... Does this look like an Interger to you ? #{y}"
      puts "You are why we can't have nice things..."
      exit 1
    end
  end
end

def speak_it(message, repeat, randomizer)
 # run the loop to print the stuff
  trigger = randomizer / 2
  chance  = rand(randomizer)
  # for debugging
  #puts trigger
  #puts chance

  # clear the screen so we can start. comment out during debugging.
  system('clear')
  my_count = 0
  while my_count <= repeat
    message.each do |char|
      unless chance == trigger
        print char
        sleep(1.0/4.0)
      else
        random_char
        print @letter
        sleep(1.0/4.0)
      end
    end
    my_count += 1
  end
end

check_the_facts(repeat, randomizer)
speak_it(message, repeat, randomizer)
