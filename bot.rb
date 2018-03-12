require 'pp'
require 'twitter'
require 'slack-ruby-client'
require_relative './lib/docomo'
require_relative './ako'

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
  if data.channel == "C9PDZET9V"
    # docomoAPI用のcontext
    context = ""

    if data.text == "おはようございます"
      params = {
        channel: "C9PDZET9V",
        text: "おはようございます"
      }
      client.message(params)
    elsif data.text =~ /^tweet (.*)/
      # /^tweet (.*)/ で $1 をメッセージとしてツイート
      tweet_text = $1
      # DM を弾きます
      if tweet_text =~ /^[dD][mM]? .*/ || tweet_text =~ /[mM] @.*/
        params = makeParam("ダイレクトメッセージはダ(イレクト)メ(ッセージ)です。")
        client.message(params)
      else
        result = rest_client.update(tweet_text + " from #reiankyo")
        params = makeParam("呟きました。https://twitter.com/jf_nights/status/#{result.id}")
        client.message(params)
      end
    elsif data.text =~ /^[dｄ] (.*)/
      # docomo の雑談API
      # /^[d|ｄ] (.*)/ で $1 をメッセージとする
      text = $1
      response = DocomoAPI.post(text, context)

      if response["requestError"] == nil
        message = response["utt"] + " [d]"
        context = response["context"]
        client.message(makeParam(message))
      else
        # error!
        client.message(makeParam(response))
      end
    elsif data.text =~ /^[qQ][aA] (.*)/
      # docomo の知識Q&A API
      # /^[qQ][aA] (.*) で $1 を質問内容とする
      text = $1
      response = DocomoAPI.postQA(text)
      client.message(makeParam(response.to_s + " [Q&A]"))
    end
  end
end

client.start!
