require_relative './lib/docomo'
# どういった機能で返事をするか
# メッセージをdataで受け取った場合、中身こんなん
# {
#   "type"=>"message",
#   "channel"=>"C9PDZET9V",
#   "user"=>"U035ULAP5",
#   "text"=>"わいわい",
#   "ts"=>"1520867007.000795",
#   "source_team"=>"T0321RSJ5",
#   "team"=>"T0321RSJ5"
# }
class Responder
  def initialize(dictionary)
    @dictionary = dictionary
  end

  def response
    return nil
  end
end

=begin
# docomoの雑談API
class DocomoResponder < Responder
  def response(text, context)
    response = DocomoAPI.post(text, context)

    if response["requestError"] == nil
      # 成功時は"返事 [by DocomoAPI]" で返す
      message = response["utt"] + " [by DocomoAPI]"
      context = response["context"]
      return {"message"=>message, "context"=>context}
    else
      # 失敗時はresponseをそのまま返し、contextは空にする
      return {"message"=>response, "context"=>nil}
    end
  end
end
=end

# ～とはなんですか
class WhatResponder < Responder
  def response(text)
    resp = "#{text}とはなんですか？"
  end
end

# Randomに返す
class RandomResponder < Responder
  def response(text)
    resp = @dictionary.random[rand(@dictionary.random.size)]
  end
end
