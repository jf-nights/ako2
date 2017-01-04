require 'json'
require 'open-uri'

TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]
ENV['SLACK_API_TOKEN'] = TOKEN
def postMessage(message)
  system("slack chat postMessage --text=\"#{message}\" --channel=\"#reiankyo\" --as_user=\"true\" --username=\"ako\" --icon_emoji=\"ako\"")
end

API_KEY = open("/home/jf712/.weather/ako").read.split("\n")[0]
BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

response = open(BASE_URL + "/daily?id=1857910&cnt=1&units=metric&APPID=#{API_KEY}")
result = JSON.parse(response.read)

desc = result["list"][0]["weather"][0]["description"]
rain = result["list"][0]["rain"]
max = result["list"][0]["temp"]["max"]
min = result["list"][0]["temp"]["min"]
icon = result["list"][0]["weather"][0]["icon"]
icon_url = "http://openweathermap.org/img/w/#{icon}.png"

description = "今日の京都の天気は #{desc}"
sub = "気温は#{min}℃～#{max}℃で、降水確率は#{rain.to_f * 100}%です。"

postMessage(description)
postMessage(sub)
postMessage(icon_url)
