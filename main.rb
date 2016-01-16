require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/activerecord"
require './models/goan_item'


set :database, {adapter: "sqlite3", database: "GoanItems"}
#
item1 = GoanItem.new
item1.name = "Beer"
item1.cost = 200

item2 = GoanItem.new
item2.name = "Fish Thali"
item2.cost = 100
item1.save
item2.save

get '/' do
  erb :landing
end

get '/compare' do
  erb :compare
end
