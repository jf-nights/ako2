Bundler.require
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative './sinatra/config'
require_relative './lib/uma.rb'

SQLITE = "/home/jf712/projects/ako2/data/db/goldpoint.sqlite3"
set :database, {adapter: "sqlite3", database: SQLITE}

# 明細を保存するtable
class Goldpoint < ActiveRecord::Base
end

# カテゴリを保存するtable
class Category < ActiveRecord::Base
  self.table_name = "category"
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
 @result = Goldpoint.find_by_id(id)
 if @result == nil
   "idが#{params[:id]}のデータなし！" 
 else
   @year = @result.date.split("/")[0]
   @month = @result.date.split("/")[1]
   erb :edit_indivisual
 end
end

# /edit/:id からid の内容を登録するときに呼ばれる
post "/regist/:id" do
  id = params[:id]
  data = Goldpoint.find_by_id(id)
  if data == nil
    session[:msg] = "記録失敗！"
  else
    # Goldpointへの登録
    data.category1 = params[:category1]
    data.category2 = params[:category2]
    data.save

    # Categoryへの登録
    category = Category.new
    category.payee = data.payee
    category.category1 = params[:category1]
    category.category2 = params[:category2]
    category.save

    session[:msg] = "記録成功！"
  end
  redirect to("/edit/#{id}")
end

# 支払い先，分類1, 分類2の一覧
get "/categories" do
  @result = Category.all
  @msg = session[:msg]
  erb :categories
end

# 支払い先，分類1，分類2を登録するときに呼ばれる
post "/registCategory" do
  payee = params[:payee]
  c1 = params[:category1]
  c2 = params[:category2]
  @msg = nil
  if payee.present? && c1.present? && !c2.nil?
    data = Category.new
    data.payee = payee
    data.category1 = c1
    data.category2 = c2
    data.save
    session[:msg] = "保存成功！"
  else
    session[:msg] = "保存失敗！"
  end
  redirect "/categories"
end

# 登録済みの支払い先，分類1などを削除する
post "/deleteCategory" do
  id = params[:id]
  data = Category.find_by_id(id)
  if data == nil
    session[:msg] = "削除失敗！"
  else
    data.destroy
    session[:msg] = "削除成功！"
  end
  redirect "/categories"
end

get '/umamusume' do
  @result = session[:checkumaresult] if !session[:checkumaresult].nil?
  erb :umamusume
end

post "/checkuma" do
  result = []
  data = params[:syutuba]
  data = data.split("\n")
  data.each do |uma|
    next if uma == nil
    #p name = uma.split("\r\n")[0]
    name = uma.gsub(/\r/, "")
    pedigree = get_pedigree(name)
    sleep(0.5)
    result << pedigree
  end

  session[:checkumaresult] = result
  redirect "/umamusume"
end
