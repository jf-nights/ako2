Bundler.require
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative './sinatra/config'

SQLITE = "/home/jf712/projects/ako2/data/db/goldpoint.sqlite3"
set :database, {adapter: "sqlite3", database: SQLITE}

class Goldpoint < ActiveRecord::Base
end

get "/" do
  "hello~~~~"
end

# /4ケタ/2ケタ へのアクセス
get %r{/([\d]{4})/([\d]{2})} do |year, month|
  @year = year
  @month = month
  @result = Goldpoint.where("date like ?", "%#{year}/#{month}%")
  pp @result.all
  if @result.all == []
    erb :noyearmonth
  else
    erb :yearmonth
  end
end

# /edit/:id へのアクセス
get %r{/edit/([\d]+)} do |id|
 pp @result = Goldpoint.find_by_id(id)
 if @result == nil
   "idが#{params[:id]}のデータなし！" 
 else
   erb :edit_indivisual
 end
end

post "/regist/:id" do
  pp params
  id = params[:id]
  data = Goldpoint.find_by_id(id)
  if data == nil
    puts "nil~~~~~~~~~~~~~~~~~~~~~~~~"
  else
    # DBへの登録
    data.category1 = params[:category1]
    data.category2 = params[:category2]
    data.save
    puts "regist~~~~~~~~~~~~~~~~~~~~~~~"
  end
  redirect to("/edit/#{id}")
end
