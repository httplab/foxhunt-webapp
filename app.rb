require 'sinatra'
require 'sinatra/activerecord'
require 'json'

configure do
  ROOT = ::File.dirname(__FILE__)
  Dir.glob(ROOT + '/models/*', &method(:require))

  require 'erb'
  @db_settings = YAML::load(ERB.new(IO.read("config/database.yml")).result)
  ActiveRecord::Base.establish_connection @db_settings['development']
end

get '/fix' do
  redirect '/foxes'
end

post '/fix' do
  p "Fix: [#{params.inspect}]"
  Device.find_or_create_by_device_id_and_sim_id :device_id => params[:device_id], :sim_id => params[:sim_id]
  fix = Fix.create :lat => params[:lat],
                   :lon => params[:lon],
                   :alt => params[:alt],
                   :acc => params[:acc],
                   :client_time => params[:client_time] || Time.now,
                   :provider_id => params[:provider_id],
                   :device_id => params[:device_id],
                   :user_id => params[:user_id],
                   :speed => params[:speed],
                   :bearing => params[:bearing]
  content_type :json
  if fix.save
    Fox.all.to_json
  else
    puts "Error: #{fix.errors.first.full_messages}"
    error 400, fix.errors.to_json
  end
end

get '/foxes' do
  content_type :json
  Fox.all.to_json
end

post '/foxes' do
  content_type :json
  Fox.all.to_json
end
