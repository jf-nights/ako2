require 'pp'
require 'slack-ruby-client'
require_relative './ako'

# 見ちゃダメよ
TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

# 阿古さん本体
ako = Ako.new(client)

client.on :hello do
  params = {
    channel: "C9PDZET9V",
    text: "システム起動しました"
  }
  client.message(params)
  puts "connected!"
end

client.on :message do |data|
  # とりあえず #ako-secret-memo のときのみ
  if data.channel == "C9PDZET9V"
    pp data
    ako.recieve(data)
  end
end

client.start!
