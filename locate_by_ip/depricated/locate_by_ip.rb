#!/usr/bin/env ruby
# - ruby script to call ipinfo-io and geektool
# Verison 1.0
###############################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end
require 'curb'
require 'yaml'

date = Time.now
puts "Current IP Location Info as of [#{date}]"
resolver = 'ipinfo.io'
ip_get = Curl.get(resolver)
ip_dump = ip_get.body
ip_yaml = YAML.load(ip_dump)

ip_yaml.each do |key, value|
  puts "#{key}: #{value}"
end

