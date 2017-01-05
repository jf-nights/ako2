# 占いAPIは
# powerd by <a href="http://jugemkey.jp/api/waf/api_free.php">JugemKey</a>
# 【PR】<a href="http://www.tarim.co.jp/">原宿占い館 塔里木</a>
# をお借りしています
require 'json'
require 'open-uri'
require_relative './post_to_slack'

def postTodayHoroscope()
  today = Time.now.strftime("%Y/%m/%d")
  url = "http://api.jugemkey.jp/api/horoscope/free/#{today}"
  response = open(url)
  result = JSON.parse(response.read)
  horoscopes = result["horoscope"]["#{today}"]
  cancer = horoscopes.select {|h| h["sign"] == "蟹座"}

  desc = "本日のラッキーアイテムは #{cancer[0]["item"]} です。"
  SlackLib.postMessage(desc)
end

postTodayHoroscope()
