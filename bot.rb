Bundler.require

# 水温計
DEVICE_W_ID = "28-0516a4c7a8ff"
result = `cat /sys/bus/w1/devices/#{DEVICE_W_ID}/w1_slave`
temperature_w = (result.split("\s").last.gsub("t=","").to_i / 1000.0).round(2)
DEVICE_A_ID = "28-0516a353feff"
result = `cat /sys/bus/w1/devices/#{DEVICE_A_ID}/w1_slave`
temperature_a = (result.split("\s").last.gsub("t=","").to_i / 1000.0).round(2)


# 見ちゃダメよ
TOKEN = open("/home/pi/.slack/ako").read.split("\n")[1]

# Slackに投稿する時のparam(channel を書くのが面倒だった)
def makeParam(text, channel="C03ANSF4X")
  params = {
    channel: channel,
    text: text
  }
  return params
end

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

client.on :hello do
  puts "connected!"
end

client.on :message do |data|
  if data.channel == "C03ANSF4X"
    if data.text == "test"
      params = makeParam("test")
      client.message(params)
    elsif data.text == "水温"
      params = makeParam("現在のぺとらさんの水温は #{temperature_w}℃です！")
      client.message(params)
    elsif data.text == "室温"
      params = makeParam("現在のお部屋の温度は #{temperature_a}℃です！")
      client.message(params)
    end
  end
end

client.start!
