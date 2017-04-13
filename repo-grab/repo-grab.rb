#!/usr/bin/env ruby
#
# - repo-grab.rb
# -- for setting up a new machine and grabbing all your repos from places.
#
# -- assumes a feeder file formatted as such:
#    # is ignored and treated as comments
#    file:ignore:filename     is treated a as file and not a repo and is ignored
#    svn:host:repo_path       currently disabled as I'm moving away from svn
#    git:host:user:repo       git repos
#
#
###############################################################################
if RUBY_VERSION.to_f <  1.9
  require 'rubygems'
end

@options = {}
parser = Option