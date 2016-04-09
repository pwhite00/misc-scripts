#!/usr/bin/env ruby
#
#
# - check for a live vpn connection and report whether we havea  secure connection or not.
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

interface_dump = `ifconfig | grep POINTOPOINT`.split("\n")
@ifc = []
interface_dump.each do |raw_dump|
  interface = raw_dump.split(":")[0]
  unless Facter.value("ipaddress_#{interface}").nil?
    @ifc.push(interface)
  end
end

#
if @ifc.count < 1
  # no vpn skip to non secure message
  @ifc.push(nil)
end

@ifc.each do |vpn_int|
  vpn_ip = Facter.value("ipaddress_#{vpn_int}")
  # what is the date/time
  date = Time.now




  # check if interface exists
  unless Facter.value("ipaddress_#{vpn_int}").nil?
  # use this url
    base_url  = 'ip-api.com'
    base_path = '/json/'
    # get a dump from teh url
    raw = Net::HTTP.get(base_url, base_path)
    # make is parsable
    parsed = JSON.parse(raw)

    puts <<VPN_ON
    VPN is Active
    Interface: #{vpn_int}
    Internal IP: #{Facter.value("ipaddress_#{vpn_int}")}
    External IP: #{parsed['query']}
    VPN Exit Point: #{parsed['city']}, #{parsed['country']}
    Connection: SECURE
VPN_ON
  else
    puts <<VPN_OFF
    VPN is OFF
    Connection: NOT SECURE
    Interface: #{vpn_int}
VPN_OFF
  end
end


