#!/usr/bin/env ruby
#
#  - grab those repos and make them update.
#
#
#############################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end
require 'optparse'

@version = '1.0'
@options = {}
parser = OptionParser.new do |opts|
  opts.banner = "#{$0}  Version: #{@version}\n  Usage: #{$0} [args]"
  opts.separator ''
  opts.on('-h', '--help', 'Display helpful usage statements.') do 
    puts opts
    exit
  end
  opts.on('-u', '--update REPO', 'Pulls fresh updates from a named repo (defaults to all known repos if blank') do |x|
    @options[:repo] = x
  end
  opts.on('-v', '--verbose', 'Run in verbose mode') do
   @options[:verbose] = true
  end
end
parser.parse!

unless @options.key?(:repo)
  @options[:mode] = :all
end

def pull_repo(repo_type, repo)
  # go ahead and grab it all
  case repo_type
  when :svn
    puts "-- Grabbing: #{repo} via subversion. --"
    svn_pull = `svn up #{repo}`
    if @options[:verbose]
      puts svn_pull
    else
      svn_pull
    end
  when :git
    puts "-- Grabbing: #{repo} via git. --"
    git_pull = `cd #{repo} && git pull && cd ../`
    if @options[:verbose]
      puts git_pull
    else
      git_pull
    end
  when :norepo
    puts "-- Ignoring: #{repo} is not a version controlled repo. --"
  end
end

def repo_fingerprint(repo)
  # figure out if a repo is svn or git
  if Dir.exists?("#{repo}/.svn")
    @repo_type = :svn
  elsif
    Dir.exists?("#{repo}/.git")
    @repo_type = :git
  else
    @repo_type = :norepo
  end
    pull_repo(@repo_type, repo)
end

unless @options[:mode] == :all
  repo_fingerprint(@options[:repo])
else
  repo_list = `ls`.split("\n")
  repo_list.each do |repo|
    if Dir.exists?(repo)
      repo_fingerprint(repo)
    end
  end
end
