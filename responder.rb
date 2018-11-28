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

  def response(text, parts, mood)
    return nil
  end
end

# ～とはなんですか
class WhatResponder < Responder
  def response(text)
    resp = "#{text}とはなんですか？"
  end
end

# Randomに返す
class RandomResponder < Responder
  def response(text, parts, mod)
    resp = @dictionary.random[rand(@dictionary.random.size)]
  end
end

class PatternResponder < Responder
  def response(text, parts, mood)
    @dictionary.pattern.each do |ptn_item|
      if m = ptn_item.match(text)
        resp = ptn_item.match(text)
        resp = ptn_item.choice(mood)
        next if resp.nil?
        return resp.gsub(/%match%/, m.to_s)
      end
    p 'pattern resp'
    end
  end
end
