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

configure :development do |config|
  config.enable :reload
end

get '/fix' do
  redirect '/foxes'
end
post '/fix' do
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
post '/foxes/:id' do |fox_id|
  content_type :json
  fox = Fox.find fox_id
  if fox.present?
    fox.update_attributes :name => params[:name], :lat => params[:lat], :lon => params[:lon]
    redirect '/foxes'
  else
    error 400, "Fox [#{fox_id}] not found"
  end
end

get '/users' do
  content_type :json
  User.all.to_json
end
get '/users/:id/devices' do |user_id|
  content_type :json
  u = User.find_by_id user_id
  if u.present?
    u.devices.to_json
  else
    error 400, "User [#{user_id}] not found"
  end
end

get '/devices' do
  Device.all.to_json
end