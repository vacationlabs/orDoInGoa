at_exit {GoanItem.destroy_all}

require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/activerecord"
require './models/goan_item'


set :database, {adapter: "sqlite3", database: "GoanItems"}

item1 = GoanItem.new
item1.name = "Beer"
item1.cost = 50

item2 = GoanItem.new
item2.name = "Fish Thali"
item2.cost = 100




item3 = GoanItem.new
item3.name = "Cashewnuts"
item3.cost = 20


item4 = GoanItem.new
item4.name = "Feni"
item4.cost = 200


item5 = GoanItem.new
item5.name = "Port Wine"
item5.cost = "250"


item6 = GoanItem.new
item6.name = "EDM Festival Pass"
item6.cost = "12000"

item1.save
item2.save
item3.save
item4.save
item5.save
item6.save


before do
  @item1name = item1.name
  @item1cost = item1.cost
  @item2name = item2.name
  @item2cost = item2.cost
  @item3name = item3.name
  @item3cost = item3.cost
  @item4name = item4.name
  @item4cost = item4.cost
  @item5name = item5.name
  @item5cost = item5.cost
  @item6name = item6.name
  @item6cost = item6.cost

end



get '/' do
  erb :landing
end

post '/display' do
  @selected_cost = params[:selected_cost]
  erb :display
end

get '/compare' do
  erb :compare
end
