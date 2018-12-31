require 'pp'
require 'slack-ruby-client'
require_relative './ako'
require_relative './reminder/post_to_slack'

# 見ちゃダメよ
TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

# as_user: true とか link_names: true とか
web_client = Slack::Web::Client.new

# 阿古さん本体
ako = Ako.new(client, web_client)

# 起動時
client.on :hello do
  SlackLib.postMessage("システム起動しました！", "#reian-test")
  puts "connected!"
end

# メッセージ受信
client.on :message do |data|
  # C9PDZET9V #ako-secret-memo
  # C03ANSF4X #reiankyo
  # CB8CHL7CM #どこやっけ
  # GEPND1JG2 #reian-test
  puts data.channel
  if data.channel == "C9PDZET9V" || data.channel == "CB8CHL7CM" || data.channel == "GEPND1JG2"
    if data.user != "U03K389H4"
      puts "recieve"
      ako.recieve(data)
    end
  end
end

# 切断時
client.on :close do |data|
  # わざわざこのためだけに使うのもアレやけど......
  SlackLib.postMessage("システム終了します......", "#ako-secret-room")
end

# 切断完了時
client.on :closed do |data|
  puts "Client has disconnected successfully!"
end

client.start!
