begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  #skip
end
require 'pusher'
require './lib/pub_sub'
require_relative 'app/clicker_app'
require "backports"
