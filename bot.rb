require 'pp'
require 'slack-ruby-client'
require_relative './ako'
require_relative './reminder/post_to_slack'

# 見ちゃダメよ
TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

# 阿古さん本体
ako = Ako.new(client)

client.on :hello do
  client.message(makeParam("システム起動しました！"))
  puts "connected!"
end

client.on :message do |data|
  # とりあえず #ako-secret-memo のときのみ
  if data.channel == "C9PDZET9V"
    pp data
    ako.recieve(data)
  end
end

client.on :close do |data|
  # わざわざこのためだけに使うのもアレやけど......
  SlackLib.postMessage("システム終了します......", "#ako-secret-room")
  puts "Client is about to disconnect"
end

client.on :closed do |data|
  puts "Client has disconnected successfully!"
end

client.start!
