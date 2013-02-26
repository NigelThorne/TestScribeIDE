#!/usr/bin/env ruby 
#

require "rubygems"
require "gtk2"
require "gtksourceview2"
require "require_all"
require "yaml" #needed
require "net/http" #needed
require "net/https" #needed
require "find" #needed
require "fileutils" #needed
require "rubygems/installer"
require "rubygems/uninstaller"
require "rubygems/builder"
require "rubygems/specification"


#make program output in real time so errors visible
STDOUT.sync = true
STDERR.sync = true

my_path = File.expand_path(File.dirname(__FILE__))
require "vrlib"

require_all Dir.glob(my_path + "/bin/**/*.rb") # cant require_all root because .rb files in root will run????

VR_Main.new(ARGV)


