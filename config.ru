require 'rubygems'
require 'sinatra'

set :environment, :production
disable :run, :reload

require './app.rb'
run Sinatra::Application