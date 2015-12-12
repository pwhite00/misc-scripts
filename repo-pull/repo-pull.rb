#!/usr/bin/env ruby
#
#  - grab those repos and make them update.
#
#  - working out better checks for whether to try pulling somthing
#   -- logic error on selection. also make it more flexible.
#
##################################################################
if RUBY_VERSION.to_f < 1.9
  require 'rubygems'
end
require 'optparse'

@version = '1.1'
@options = {}
@myline = '-------------------------------------'
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
  opts.on('-s', '--only-svn', 'Pull only svn repos') do
    @options[:nogit] = true
  end
  opts.on('-g', '--only-git', 'Pull only git repos') do
    @options[:nosvn] = true
  end
end
parser.parse!

unless @options.key?(:repo)
  # does @options[:repo] exist as a key ? if not make it = :all
  @options[:mode] = :all
end

unless @options.key?(:nosvn)
  # does @options[:nosvn] exist as a key ? if not make it = false
  @options[:nosvn] = false
end

unless @options.key?(:nogit)
  # does @options[:nogit] exist as a key ? if not make it = false
  @options[:nogit] = false
end

if @options[:verbose]
# test if :nogit and :nosvn flags were used and recorded
  puts "nogit == #{@options[:nogit]}"
  puts "nosvn == #{@options[:nosvn]}"
end


def pull_repo(repo_type, repo)
  # go ahead and grab it all
  case repo_type
  when :svn
      unless @options[:nosvn]
        puts "-- Grabbing: #{repo} via subversion. --"
        svn_pull = `svn up #{repo}`
        if @options[:verbose]
          puts @myline
          puts svn_pull
          puts
        else
          svn_pull
        end
      else
        puts "- Skipping #{repo} due to no svn option. -"
      end
  when :git
      unless @options[:nogit]
        puts "-- Grabbing: #{repo} via git. --"
        git_pull = `cd #{repo} && git pull && cd ../`
        if @options[:verbose]
          puts @myline
          puts git_pull
          puts
        else
          git_pull
        end
      else
        puts "- Skipping #{repo} due to no git option. -"
      end
  when :norepo
    puts "- Ignoring: #{repo} is not a version controlled repo. -"
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
