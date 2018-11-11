require 'pp'
require 'json'
require 'open-uri'

def select_channel
  token = open("/home/jf712/.slack/ako").read.split("\n")[1]
  res = open("https://slack.com/api/channels.list?token=#{token}&pretty=1", &:read)
  json = JSON.parse(res)

  channels = []
  parsed = json["channels"]
  parsed.each do |c|
    if c["is_private"] == false && c["is_archived"] == false
      channels << c["name"] 
    end
  end
  return channels[rand(channels.size)]
end
