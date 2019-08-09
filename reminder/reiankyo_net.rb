# 進捗！！！
require_relative './post_to_slack'

message = ""
#if Time.now.hour == 6 
  status = `curl -LI reiankyo.net -o /dev/null -w '%{http_code}\n' -s`
  status = status.chomp.to_i

  message = "status : #{status} "
  if status == 200
    message += ":ok_man:"
  elsif
    message += ":sad_panda:"
  end
#end
SlackLib.postMessage(message, "#reian-test")
