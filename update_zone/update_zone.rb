#!/usr/bin/env ruby
#
# - update_zone.rb
#
###############################################################################
@zonefile  = ARGV[0]
@zone_path = '/var/named/zones'  # Update this to your path to you zone files.


def usage()
  usage_msg = <<END

  Usage: #{$0} {arg}
    -h, --help
    zone filename
END
  puts usage_msg
  exit 0
end

if @zonefile == '-h' or @zonefile == '--help' or @zonefile.nil?
  usage
end


