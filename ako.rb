require_relative './lib/docomo'

# 阿古さん本体
class Ako
  def initialize(client)
    @client = client
    @context = ""
  end

  def makeParam(text, channel="C9PDZET9V")
    params = {
      text: text,
      channel: channel
    }
    return params
  end

  # メッセージを受け取る際の関数
  # 今のところ受け取るdataの中身こんんあん
  # {
  #   "type"=>"message",
  #   "channel"=>"C9PDZET9V",
  #   "user"=>"U035ULAP5",ぼく(jf712)
  #   "text"=>"わい",
  #   "ts"=>"1520867007.000795",
  #   "source_team"=>"T0321RSJ5",
  #   "team"=>"T0321RSJ5"
  # }
  def recieve(data)
    if data.text == "おやすみなさい"
      @client.message(makeParam("おやすみなさいませ"))
    end

    # ---------------------------
    # docomo の雑談API
    # ---------------------------
    if data.text =~ /^[dｄ] (.*)/
      text = $1
      response = DocomoAPI.post(text, @context)

      if response["requestError"] == nil
        message = response["utt"] + " [by docomoAPI]"
        @context = response["context"]
        @client.message(makeParam(message))
      else
        @client.message(makeParam(response))
      end
    end
  end
end
