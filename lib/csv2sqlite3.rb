require 'sqlite3'
require 'nkf'
require 'active_record'

#set :database, {adapter: "sqlite3", database: "./data/db/goldpoint.sqlite3"}

# goldpointの明細CSVからテーブルにいい感じに入れてくれるやつ
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "/home/jf712/projects/ako2/data/db/goldpoint.sqlite3"
)

class Goldpoint < ActiveRecord::Base
end

FILE_NAME = "/home/jf712/projects/ako2/money/201910.csv"
open(ARGV[0]) do |file|
  file.each_line do |line|
    # 全角を半角にしてから，カタカナは全角に戻す"
    line = NKF.nkf('-w -X', NKF.nkf('-w -Z4', line))
    vals = line.split(",")
    attr = {
      date: vals[0],
      payee: vals[1],
      amount: vals[5],
      installment: vals[3],
      numberinstallment: vals[4],
      category1: "",
      category2: ""
    }
    goldpoint = Goldpoint.new(attr)
    goldpoint.save!
  end
end

pp Goldpoint.all
