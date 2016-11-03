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
require 'fileutils'

# database lives @ env['Home']/.1kc

# create an alias in .bashrc to display a current count

@options = { :version => 1.0,
             :import => nil,
             :note => nil,
             :mode => 'status',
             :verbose => false,
             :db => "#{env['HOME']}/.ikcdb/ikc.db",
             :dbPath => "#{env['HOME']}/.kcdb",
             :value  => 1 ,
}

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
  opts.on('-o', '--override-value VALUE', 'If a cut warrents it add a number value [defaults to 1].') do |x|
    @options[:value] = x
  end
end
parser.parse!

def getStatus(isVerbose)
  # How many cuts are left.
  printf("getStatus\n")
  # read current count and report
  # if verbose report more
  unless File.exists?(@options[:db])
    printf("Unable to locate database. Clearly this is just one more cut...\n")
    exit 67
  end
  db = SQLite3::Database.new(@options[:db])
  count = db.execute("select value from cuts;")
  printf("Current cuts [#{count}]\n")
  exit
end

def setupDb(importDb, isVerbose)
  # importDB is @options[:import]
  printf("setup\n")
  # check if the file exists
  file_is_there = File.exists?(:db)
  unless @options[:importDb].nil?
    if file_is_there
      printf(" - Unable to import database [#{@options[:importDb]}] database already exists." )
      exit 1
    else
      unless Dir.exist?(@options[:dbPath])
        FileUtils.mkdir_p(@options[:dbPath], mode => 0755)
      end
      FileUtils.cp(@options[:importDb], @options[:db])
      # print a message
    end
  else
    # make the db
    mkFreshDb
  end
  exit
end

def makeFreshDb()
  # make a sqlite db
  # schema:  CREATE TABLE cuts (value Integer, timestamp TEXT, comment TEXT)
  db = SQLite3::Database.new(@options[:db])
  db.execute("CREATE TABLE cuts (value Integer, timestamp TEXT, comment TEXT)")
  printf("Created a new database [#{@options[:db]}\n")
end

def addEntry(addMsg, isVerbose)
  # addMsg is @options[:note]
  printf("addEntry\n")
  # check for message
  # if verbose report more
  # add tally with message if included.
  unless File.exists?(@options[:db])
    printf("Unable to locate database. Clearly this is just one more cut...\n")
    exit 67
  end
  db = SQLite3::Database.new(@options[:db])
  unless @options[:note].nil?
    db.execute("INSERT INTO cuts (value, timestamp, comment) VALUES (#{@options[:value]}, #{timestamp}, #{@options[:note]})")
  else
    db.execute("INSERT INTO cuts (value, timestamp, comment) VALUES (#{@options[:value]}, #{timestamp}, #{@options[:note]})")
  end
  printf("a #{value} point cut has been registered.\n")
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
