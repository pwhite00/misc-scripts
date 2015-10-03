#!/usr/bin/env ruby
#
# - sanity.rb
#
# swap put argv for optparse
# add in better error checking and a usage
#
#
##################################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end
  require 'optparse'

@options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [args]"
  opts.separator ''
#  opts.banner = "Arguments:"
  opts.on('-h', '--help', 'Display Help.') do
    puts opts
    exit
  end
  opts.on('-r', '--repeat COUNT', 'How many times should the message display ?') do |x|
    @options[:repeat] = x
  end
  opts.on('-f', '--frequency FREQUENCY', 'Pick a number. Higher number mean less errors in the message.') do |x|
    @options[:randomizer] = x
  end
end
parser.parse!

## How may times should it loop ?
if @options[:repeat].nil?
  repeat = 20
else
  repeat = @options[:repeat].to_i
end

# Pick a random number to see how often you want to introduce typoes.
# Lower numbers will generate a higher number of errors.
if @options[:randomizer].nil?
  randomizer = 200
else
  randomizer = @options[:randomizer].to_i
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
     # puts "Upper"
      @letter = letter.upcase
    else
     # puts "lower"
      @letter = letter
    end
end

def random_char()
  # Find a random letter in the alphabet when triggered.
  alpha = 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
  new_char = alpha[rand(25)]
  # puts new_char
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

  # clear the screen so we can start. comment out during debugging.
  system('clear')
  my_count = 0
  while my_count <= repeat
    message.each do |char|
      trigger = randomizer / 2
      chance  = rand(randomizer)
      # for debugging
      # puts trigger
      # puts chance
      unless chance == trigger
        print char
        sleep(1.0/4.0)
      else
        #puts "triggered"
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
