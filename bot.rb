require 'pp'
require 'twitter'
require 'slack-ruby-client'

# Twitterぶぶん
twitter_token = open("/home/jf712/.twitter/jf_nights").read.split("\n")
rest_client = Twitter::REST::Client.new do |c|
  c.consumer_key = twitter_token[0]
  c.consumer_secret = twitter_token[1]
  c.access_token = twitter_token[2]
  c.access_token_secret = twitter_token[3]
end

# 見ちゃダメよ
TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]

Slack.configure {|c| c.token = TOKEN}
client = Slack::RealTime::Client.new

client.on :hello do
  puts "connected!"
end

client.on :message do |data|
  pp data
  if data.text == "おはようございます"
    params = {
      channel: "C03ANSF4X",
      text: "おはようございます"
    }
    client.message(params)
  elsif data.text =~ /^tweet (.*)/
    tweet_text = $1
    # DM を弾きます
    if tweet_text =~ /^[dD][mM]? .*/ || tweet_text =~ /[mM] @.*/
      puts "DIRECT MESSAGE"
       params = {
        channel: "C03ANSF4X",
        text: "ダイレクトメッセージはダ(イレクト)メ(ッセージ)です。"
      }
      client.message(params)
    else
      result = rest_client.update(tweet_text + " from #reiankyo")
      params = {
        channel: "C03ANSF4X",
        text: "呟きました。https://twitter.com/jf_nights/status/#{result.id}"
      }
      client.message(params)
    end
  end

end

client.start!
