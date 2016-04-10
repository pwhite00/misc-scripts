#!/usr/bin/env ruby
#
# - mini-sysstat.rb: Script display current important system stats for use with
#   Geektool
#
###############################################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end

require 'facter'

# uptime
uptime = Facter.value('uptime')
# hostname
hostname = Facter.value('hostname')
# os version
os = "#{Facter.value("os")["name"]}:#{Facter.value("os")["release"]["full"]}"
# disks and space
@disks = []
def disk_process()
  disk_raw = `df -h | grep '/dev/disk'`.split("\n")
  disk_raw.each do |disk|
    disk_split = disk.split
    @disks.push(disk_split)
  end
  @disks.each do |disk|
  mount  = disk[8]
  total  = disk[1]
  used   = disk[2]
  free   = disk[3]
  used_p = disk[4]
  @disk_out = "Filesystem: #{mount} Total:#{total}, Used:#{used}, Free:#{free}, Usage %:#{used_p}"
  end
end
disk_process

# load
load_raw = `w | grep load | grep -v grep | cut -d ':' -f 4`.chop.split
load = "#{load_raw[0]}, #{load_raw[1]}, #{load_raw[2]}, "

# memory and usage
memory = "#{Facter.value('memoryfree')}/#{Facter.value('memorysize')}"

# cpus and usage
cpus = "#{(Facter.value'sp_cpu_type')}, Count:#{Facter.value('processors')[0]}, Speed:#{Facter.value('processors')[0]}"

puts <<output_report
Hostname: #{hostname} OS #{os}
Uptime: #{uptime}
Load: #{load}
CPU: #{cpus}
Memory: #{memory}
#{@disk_out}
output_report