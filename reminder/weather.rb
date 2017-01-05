require 'pp'
require 'json'
require 'open-uri'

TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]
ENV['SLACK_API_TOKEN'] = TOKEN
def postMessage(message)
  system("slack chat postMessage --text=\"#{message}\" --channel=\"#reiankyo\" --as_user=\"true\" --username=\"ako\" --icon_emoji=\"ako\"")
end

def postTodayWeather()
  # weather_id の読み込み
  weather_id = JSON.load(open("../weather/weather_id.json"))

  api_key = open("/home/jf712/.weather/ako").read.split("\n")[0]
  base_url = "http://api.openweathermap.org/data/2.5/forecast"

  # APIへ
  response = open(base_url + "/daily?id=1857910&units=metric&APPID=#{api_key}")
  result = JSON.parse(response.read)
  # これが当日のforecast?なんか朝に叩くとおかしかった(最高・最低気温が同じだった
  data = result["list"][0]

  # 時間
  time = Time.at(data["dt"]).strftime("%Y/%m/%d")
  # 天気の説明
  desc = weather_id[data["weather"][0]["id"].to_s]
  # 最高気温
  max = data["temp"]["max"]
  # 最低気温
  min = data["temp"]["min"]
  # 湿度
  humidity = data["humidity"]
  # お天気アイコンとそのURL
  icon = data["weather"][0]["icon"]
  icon_url = "http://openweathermap.org/img/w/#{icon}.png"

  description = "#{time} の京都の天気は #{desc} です。"
  sub = "気温は#{min}℃～#{max}℃です。"

  # slackに発言
  postMessage(description)
  postMessage(sub)
  postMessage(icon_url)
end

def postTodayHoroscope()
  today = Time.now.strftime("%Y/%m/%d")
  url = "http://api.jugemkey.jp/api/horoscope/free/#{today}"
  response = open(url)
  result = JSON.parse(response.read)
  horoscopes = result["horoscope"]["#{today}"]
  cancer = horoscopes.select {|h| h["sign"] == "蟹座"}

  desc = "本日のラッキーアイテムは #{cancer[0]["item"]} です。"
  postMessage(desc)
end

postTodayWeather()
postTodayHoroscope()
