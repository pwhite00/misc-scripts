#!/usr/bin/env ruby
#
#
#
#
#
#
#
#
########################################################################################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end

require 'facter'
require 'net/http'
require 'json'

# define stuff
vpn_interface = 'utun0'
vpn_ip = Facter.value("ipaddress_#{vpn_interface}")
# what is the date/time
date = Time.now





# check if interface exists
unless Facter.value("ipaddress_#{vpn_interface}").nil?
  # use this url
  base_url  = 'ip-api.com'
  base_path = '/json/'
  # get a dump from teh url
  raw = Net::HTTP.get(base_url, base_path)
  # make is parsable
  parsed = JSON.parse(raw)

  puts <<VPN_ON
  VPN is Active
  Internal IP: #{Facter.value("ipaddress_#{vpn_interface}")}
  External IP: #{parsed['query']}
  VPN Exit Point: #{parsed['city']}, #{parsed['country']}
  Connection: SECURE
VPN_ON
else
  puts <<VPN_OFF
  VPN is OFF
  Connection: NOT SECURE
VPN_OFF
end


