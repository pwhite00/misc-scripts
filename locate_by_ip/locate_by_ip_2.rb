#!/usr/bin/env ruby
#
#
# locate_by_ip.rb part duex
#
# simpler code but less geographically accurate.
# ie : old version knows I'm in a specific town
#      this version knows I'm in a given state.
#      seems like a limitation of the api though.
#      adapt old url to new code ?
#
################################################
require 'net/http'
require 'json'

# what is the date/time
date = Time.now

# use this url
base_url  = 'ip-api.com'
base_path = '/json/'

# get a dump from teh url
raw = Net::HTTP.get(base_url, base_path)

# make is parsable
parsed = JSON.parse(raw)

puts date
parsed.each do |x,y|
  puts "#{x}:#{y}"
end

