#!/usr/bin/env ruby
#
# - Count the 1000 cuts to change.
#
###############################################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end

require 'optparse'
require 'sqlite3'

# database lives @ env['Home']/.1kc

# create an alias in .bashrc to display a current count

@options = { :version => 1.0, :import => nil, :note => nil, :mode => :status, :verbose => false, :db => '.1kc.db' }
@modes = ['new', 'status', 'append']
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [args]"
  opts.separator ''
  opts.on('-h', '--help', 'Display this handy help message.' ) do
    puts opts
    printf("%s\n, ", "Version: #{@options[:version]}")
    exit
  end
  opts.on('-m', '--mode MODE', "Select a Mode #{@modes}") do |x|
    @options[:mode] = x
  end
  opts.on('-i', '--import DATABASE', 'Import an existing database.') do |x|
    @options[:import] = x
  end
  opts.on('-n', '--note', 'Append a footnote to a given cut in the database.') do |x|
    @options[:note] = x
  end
  opts.on('-v', '--verbose', 'display a more verbose output.') do
    @options[:verbose] = true
  end
end
parser.parse!

def getStatus(isVerbose)
  # How many cuts are left.
  printf("getStatus\n")
  # read current count and report
  # if verbose report more
  exit
end

def setupDb(importDb, isVerbose)
  # importDB is @options[:import]
  printf("setup\n")
  # check if the file exists
  file_is_there = File.exists?(#add a db file to check)
  
  
  # if verbose report more
  # check if import is on and if import file exists ?
  # if not importing create blank db
  # if importing import
  exit
end

def addEntry(addMsg, isVerbose)
  # addMsg is @options[:note]
  printf("addEntry\n")
  # check for message
  # if verbose report more
  # add tally with message if included.
  getStatus
  exit
end

case @options[:mode]
  when 'new'
    setupDb(@options[:import], @options[:verbose])
  when 'append'
    addEntry(@options[:note], @options[:verbose])
  when 'status'
    getStatus(@options[:verbose])
  else printf("Mode [#{@options[:mode]}] is invalid.")
    exit 66
end