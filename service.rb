#!/usr/bin/env ruby
# A simple sinatra service
require 'sinatra'

get /^\/(.*?)\/(.*)$/ do |action, resource|
  "You performed #{action} on #{resource}!\n"
end


