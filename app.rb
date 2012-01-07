require 'sinatra'
require 'sinatra/activerecord'

configure do
  ROOT = ::File.dirname(__FILE__)
  require 'erb'
  @db_settings = YAML::load(ERB.new(IO.read("config/database.yml")).result)
  FileUtils.mkdir_p("log")
end

post '/:fix' do
  params.each_pair do |k, v|
    puts "#{k} = [#{v}]"
  end
end
