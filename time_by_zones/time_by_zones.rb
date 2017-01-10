#!/usr/bin/env ruby
#
# geektool ruby script that displays time by time zones
# which allows me to not have to think about what time it is in other offices
#
###############################################################################

# Check ruby version because 1.8.7 uses a different Time.now.utc format.
if RUBY_VERSION == '1.8.7'
  time_dump   = Time.now.utc.to_s.split(' ')[3]
else
  time_dump   = Time.now.utc.to_s.split(' ')[1]
end

# Define base time variables from chopped up Time and other basic variables.
@hour_raw    = time_dump.split(':')[0].to_i
@min         = time_dump.split(':')[1]
@version     = "v1.0"

# Manual flag for dst . Next version lets make this dynamic.
@dst_on = false

# set mode to use ARGV
mode = ARGV[0]

# If ARGV is not used set mode to default.
if mode.nil?
  mode = "default"
end

# a helpful usage statement.
def usage()
  msg = <<EOM

  Usage #{$0} [mode]
   help           :Display this help
   all            :Display all configured time zones
   us             :Display only US timezones
   * of {blank}   :Display IAD and SFO time only

  Version #{@version}
EOM
  puts msg
  exit 0
end

# define Timezone date and whether city observes DST
@city = {
    :cdg_offset => 1,
    :cdg_dst    => true,
    :lhr_offset => 0,
    :lhr_dst    => true,
    :iad_offset => -5,
    :iad_dst    => true,
    :ord_offset => -6,
    :ord_dst    => true,
    :den_offset => -7,
    :den_dst    => true,
    :sfo_offset => -8,
    :sfo_dst    => true,
    :hnl_offset => -10,
    :hnl_dst    => false,
    :sin_offset => 8,
    :sin_dst    => false,
    :nrt_offset => 9,
    :nrt_dst    => false,
}

def process_time(offset, dst, site)
# Define how we process time.

  # If DST flag is on determine if city uses dst and calculate hour.
  # Otherwise just determine Hour based on timezone offset.
  if @dst_on
    if dst
      @num = @hour_raw + offset.to_i + 1
    else
      @num = @hour_raw + offset.to_i
    end
  else
      @num = @hour_raw + offset.to_i
  end

  # hours wkth offset can be above or below 0 or 24.
  # define rules on what to do.
  # if less or equal to 0 take @num and + 24.
  # if greater than or equal to 24 take @num - 24.
  # otherwuse hour is just @num.
  if @num <= 0
      @newnum = 24 + @num
  elsif @num >= 24
      @newnum = @num - 24
  else
      @newnum = @num
  end

  # time output string
  "#{site}: #{@newnum}:#{@min}"

end

# Define the report called by "all" mode. Displays all configured timezones.
def full_report()
  # display all zones
  print "#{process_time(@city[:cdg_offset], @city[:cdg_dst], "CDG")}     "
  print "#{process_time(@city[:lhr_offset], @city[:lhr_dst], "LHR")}     "
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD")}     "
  print "#{process_time(@city[:ord_offset], @city[:ord_dst], "ORD")}     "
  print "#{process_time(@city[:den_offset], @city[:den_dst], "DEN")}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO")}     "
  print "#{process_time(@city[:hnl_offset], @city[:hnl_dst], "HNL")}     "
  print "#{process_time(@city[:sin_offset], @city[:sin_dst], "SIN")}     "
  print "#{process_time(@city[:nrt_offset], @city[:nrt_dst], "NRT")}     "
end

# Define the report called by "us" mode. Displays all configured US timezones.
def us_report()
  # display all US
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD")}     "
  print "#{process_time(@city[:ord_offset], @city[:ord_dst], "ORD")}     "
  print "#{process_time(@city[:den_offset], @city[:den_dst], "DEN")}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO")}     "
  print "#{process_time(@city[:hnl_offset], @city[:hnl_dst], "HNL")}     "
end

# Define the default report. Displays IAD and SFO times.
def default_report()
  # display ET and PT only
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD")}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO")}     "
end

# Case statement to define the mode to run in.
case mode
  when "all"
    full_report
  when "us"
    us_report
  when "help"
    usage
  else default_report
end

