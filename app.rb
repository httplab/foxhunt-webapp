require 'sinatra'
require 'sinatra/activerecord'
require 'json'

configure do
  ROOT = ::File.dirname(__FILE__)
  Dir.glob(ROOT + '/models/*', &method(:require))

  require 'erb'
  @db_settings = YAML::load(ERB.new(IO.read("config/database.yml")).result)
  FileUtils.mkdir_p("log")
end

post '/:fix' do
  params.each_pair do |k, v|
    puts "#{k} = [#{v}]"
  end
end

get '/:foxes' do
  content_type :json
  Fox.all.to_json
end
