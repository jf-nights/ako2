module SlackLib
  TOKEN = open("/home/jf712/.slack/ako").read.split("\n")[1]
  ENV['SLACK_API_TOKEN'] = TOKEN
  def postMessage(message)
    system("slack chat postMessage --text=\"#{message}\" --channel=\"#reiankyo\" --as_user=\"true\" --username=\"ako\" --icon_emoji=\"ako\"")
  end

  module_function :postMessage
end
