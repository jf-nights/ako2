require 'slack-ruby-client'

# 見ちゃダメよ
TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

client.on :hello do
  puts "connected!"
end

client.on :message do |data|
  if data.text == "testtt"
    params = {
      channel: "C03ANSF4X",
      text: "aaa",
    }
    client.message(params)
  end

end

client.start!
