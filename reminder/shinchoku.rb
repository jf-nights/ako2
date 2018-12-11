# 進捗！！！
require_relative './post_to_slack'

message = ""
if Time.now.hour == 12
  message = "@jf712 進捗どうですか～"
elsif Time.now.hour == 18
  message = "@jf712 進捗進捗ぅ～～"
elsif Time.now.hour == 21
  message = "@jf712 今日は進捗ありましたか？"
elsif Time.now.hour == 22
  message = "@jf712 https://scrapbox.io/reiankyo/ 何か書いてね～～～～"
end
SlackLib.postMessage(message)
