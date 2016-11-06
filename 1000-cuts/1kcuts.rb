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
             :importDb => nil,
             :note => nil,
             :mode => 'status',
             :verbose => false,
             :db => "#{ENV['HOME']}/.ikcdb/ikc.db",
             :dbPath => "#{ENV['HOME']}/.ikcdb",
             :value  => 1 ,
}

@modes = ['new', 'status', 'append']
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [args]"
  opts.separator ''
  opts.on('-h', '--help', 'Display this handy help message.' ) do
    puts opts
    printf("%s\n", "Version: #{@options[:version]}")
    exit
  end
  opts.on('-m', '--mode MODE', "Select a Mode #{@modes}") do |x|
    @options[:mode] = x
  end
  opts.on('-i', '--import DATABASE', 'Import an existing database.') do |x|
    @options[:importDb] = x
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
  # read current count and report
  # if verbose report more
  unless File.exists?(@options[:db])
    printf("Unable to locate database. Clearly this is just one more cut...\n")
    exit 67
  end
  db = SQLite3::Database.new(@options[:db])
  count = db.execute("SELECT SUM(value) FROM cuts;")
  printf("Current cuts %s\n", count)
  exit
end

def setupDb(importDb, isVerbose)
  # importDB is @options[:import]
  # check if the file exists

  # true|false the db already exists.
  file_is_there = File.exists?(@options[:db])

  # if you try and import a DB and the db already exists abort !
  unless @options[:importDb].nil?
    if file_is_there
      printf(" - Unable to import database [#{@options[:importDb]}] database already exists." )
      exit 1
    end
  end

  # if the db direcoty path doesn't exist create it and set the right permissions.
  unless Dir.exist?(@options[:dbPath])
    FileUtils.mkdir_p(@options[:dbPath], :mode => 0755)
    sleep(2)
  else
    FileUtils.chmod(@options[:dbPath], :mode => 0755)
    sleep(2)
  end

  # if import was picked go ahead and import the DB now.
  unless @options[:importDb].nil?
    printf(" - Importing database #{@options[:importDb]} to #{@options[:db]}.\n")
    FileUtils.cp(@options[:importDb], @options[:db])
    sleep(2)
    exit
  end
  # if no import and once all teh diretories have been sorted out go ahead and build a new database.
  makeFreshDb
  exit
end

def makeFreshDb()
  # make a sqlite db
  # schema:  CREATE TABLE cuts (value Integer, timestamp TEXT, comment TEXT)
  db = SQLite3::Database.new(@options[:db])
  sleep(2)
  db.execute("CREATE TABLE cuts (value Integer, timestamp TEXT, comment TEXT);")
  printf(" - Created a new database [#{@options[:db]}\n")
end

def addEntry(addMsg, isVerbose)
  timestamp = Time.now.to_s
  # addMsg is @options[:note]
  # check for message
  # if verbose report more
  # add tally with message if included.
  unless File.exists?(@options[:db])
    printf("Unable to locate database. Clearly this is just one more cut...\n")
    exit 67
  end
  db = SQLite3::Database.open "#{@options[:db]}"
  puts 'a'
  db.execute("INSERT INTO cuts VALUES (#{@options[:value]}, \'#{timestamp}\', \'#{@options[:note]}\');")
  puts 'b'
  printf("a #{@options[:value]} point cut has been registered.\n")
  puts 'c'
  getStatus(@options[:verbose])
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
