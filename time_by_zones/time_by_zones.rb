#!/usr/bin/env ruby
#
# geektool ruby script that displays time by time zones
# which allows me to not have to think about what time it is in other locations
#
###############################################################################

# Check ruby version because 1.8.7 uses a different Time.now.utc format.
#if RUBY_VERSION == '1.8.7'
#  time_dump   = Time.now.utc.to_s.split(' ')[3]
#else
#  time_dump   = Time.now.utc.to_s.split(' ')[1]
#end


time_dump   = Time.now.utc.to_s.split(' ')[1]

# Define base time variables from chopped up Time and other basic variables.
@hour_raw    = time_dump.split(':')[0].to_i
@min         = time_dump.split(':')[1]
@version     = "v1.1"

# Manual flag for dst . Next version lets make this dynamic.
@dst_on = true

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
    :utc_offset      => 0,
    :utc_dst         => false,
    :cdg_offset      => 1,
    :cdg_dst         => false,
    :cdg_variance    => 0,
    :lhr_offset      => 0,
    :lhr_dst         => false,
    :lhr_variance    => 0,
    :iad_offset      => -5,
    :iad_dst         => true,
    :iad_variance    => 0,
    :ord_offset      => -6,
    :ord_dst         => true,
    :ord_variance    => 0,
    :den_offset      => -7,
    :den_dst         => true,
    :den_variance    => 0,
    :sfo_offset      => -8,
    :sfo_dst         => true,
    :sfo_variance    => 0,
    :hnl_offset      => -10,
    :hnl_dst         => false,
    :hnl_variance    => 0,
    :hyd_offset      => 6, # sometimes 5 sometimes 6 need to refactor to allow more flexibility in dst changes.
    :hyd_dst         => false,
    :hyd_variance    => 30,
    :sin_offset      => 8,
    :sin_dst         => false,
    :sin_variance    => 0,
    :nrt_offset      => 9,
    :nrt_dst         => false,
    :nrt_variance    => 0,
}

def process_time(offset, dst, site, variance)
# Define how we process time.

  # determine @min value as it relates to variance.
  if variance == 0
    minutes = @min.to_i
  else
    minutes_raw = @min.to_i + variance.to_i
    if minutes_raw >= 60
      minutes = minutes_raw - 60
    else
      minutes = minutes_raw
    end
  end

  # cosmetic 0 padding for minutes 0-9
  if minutes < 10
    minutes = "0#{minutes}"
  end

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
  "#{site}: #{@newnum}:#{minutes}"

end

# Define the report called by "all" mode. Displays all configured timezones.
def full_report()
  # display all zones
  print "#{process_time(@city[:utc_offset], @city[:utc_dst], "UTC", @city[:utc_variance])}     "
  print "#{process_time(@city[:cdg_offset], @city[:cdg_dst], "CDG", @city[:cdg_variance])}     "
  print "#{process_time(@city[:lhr_offset], @city[:lhr_dst], "LHR", @city[:lhr_variance])}     "
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD", @city[:iad_variance])}     "
  print "#{process_time(@city[:ord_offset], @city[:ord_dst], "ORD", @city[:ord_variance])}     "
  print "#{process_time(@city[:den_offset], @city[:den_dst], "DEN", @city[:den_variance])}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO", @city[:sfo_variance])}     "
  print "#{process_time(@city[:hnl_offset], @city[:hnl_dst], "HNL", @city[:hnl_variance])}     "
  print "#{process_time(@city[:hyd_offset], @city[:hyd_dst], "HYD", @city[:hyd_variance])}     "
  print "#{process_time(@city[:sin_offset], @city[:sin_dst], "SIN", @city[:sin_variance])}     "
  print "#{process_time(@city[:nrt_offset], @city[:nrt_dst], "NRT", @city[:nrt_variance])}     \n"
end

# Define the report called by "us" mode. Displays all configured US timezones.
def us_report()
  # display all US
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD", @city[:iad_variance])}     "
  print "#{process_time(@city[:ord_offset], @city[:ord_dst], "ORD", @city[:ord_variance])}     "
  print "#{process_time(@city[:den_offset], @city[:den_dst], "DEN", @city[:den_variance])}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO", @city[:sfo_variance])}     "
  print "#{process_time(@city[:hnl_offset], @city[:hnl_dst], "HNL", @city[:hnl_variance])}     \n"
end

# Define the default report. Displays IAD and SFO times.
def default_report()
  # display ET and PT only
  print "#{process_time(@city[:utc_offset], @city[:utc_dst], "UTC", @city[:utc_variance])}     "
  print "#{process_time(@city[:iad_offset], @city[:iad_dst], "IAD", @city[:iad_variance])}     "
  print "#{process_time(@city[:sfo_offset], @city[:sfo_dst], "SFO", @city[:sfo_variance])}     \n"
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

