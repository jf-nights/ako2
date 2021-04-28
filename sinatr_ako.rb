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

get "/:year/:month" do |year, month|
  @year = year
  @month = month
  @result = Goldpoint.where("date like ?", "%#{year}/#{month}%")
  pp @result.all
  
  erb :yearmonth
end

