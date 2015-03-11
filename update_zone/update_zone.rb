#!/usr/bin/env ruby
#
# - update_zone.rb
#
###############################################################################
require 'fileutils'

# file stuff
@zone_file  = ARGV[0]
#@zone_path = '/var/named/zones'  # Update this to your path to you zone files.
@zone_path = '/Users/pwhite/repos/misc-scripts/update_zone'  # Update this to your path to you zone files.
@version = "V1.0"

# some helpfu usage statement
def usage()
  usage_msg = <<END

  Usage: #{$0} {arg}
    -h, --help
    zone filename

    Version: #{@version}
END
  puts usage_msg
  exit 0
end

#### this could be better
# did you specify you ask for help or leave the zone_file blank ?
#if @zonefile == '-h' or  @zonefile == '--help' or  @zonefile.nil?
#  usage
#end

case @zone_file
  when '-h'
    usage
  when'--help'
    usage
  when nil
    usage
end

# figure out serial voodoo
@my_file         = "#{@zone_path}/#{@zone_file}"

# check if @zone_file exists or bail
unless File.exists?(@my_file)
  puts "Your file can't be found."
  usage
end

@my_file_dumped  = File.read(@my_file)
#@starting_serial_dump = @my_file_dumped.split("\n").grep(/serial/)
@starting_serial = @my_file_dumped.split("\n").grep(/serial/).to_s.scan(/[0-9]/).join
#@starting_serial = @starting_serial_dump.scan(/[0-9]/).join
@starting_date   = @starting_serial[0..7]
@starting_count  = @starting_serial[8..12]
date_dump        = Time.now.utc.to_s.split('-')[0..2]
day_chop         = date_dump[2].split[0]
now_date        = "#{date_dump[0]}#{date_dump[1]}#{day_chop}"

unless now_date == @starting_date
  @new_count = "00"
else
  update_count = @starting_count.to_i + 1
  if update_count < 10
    @new_count = "0#{update_count}"
  else
    @new_count = update_count.to_s
  end
end

# backup original file just in case
FileUtils.cp @my_file , "#{@my_file}.BAK_#{@starting_serial}"
  unless File.exists?("#{@my_file}.BAK_#{@starting_serial}")
    puts "Error failed to backup file. Aborting."
    exit 2
  end

# edit the serial in the file

new_serial = "#{now_date}#{@new_count}"
puts "Updating #{@zone_file} serial from [#{@starting_serial}] to [#{new_serial}]."
replace_serial = @my_file_dumped.gsub(/#{@starting_serial}/, new_serial)
File.open(@my_file, 'w') do |file|
  file.puts replace_serial
end

# check that file updated and wasn't destroyed
# maybe test with diff in some sort.
# then add the rndc reload stuff
puts

