require_relative './lib/utils'
require_relative './responder'

# 阿古さん本体
class Ako
  def initialize(slack_client)
    @slack_client = slack_client
    @context = ""

    # respnoder
    @responder_DocomoAPI = DocomoResponder.new

    puts "ready......!"
  end

  # メッセージを受け取る際の関数
  # ここで受け取って各reponder#response で返事を作って返す
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
    # 発言すべき内容とチャンネルの入れもの
    param = nil

    # ---------------------------
    # 「おやすみなさい」
    # ---------------------------
    if data.text == "おやすみなさい"
      param = makeParam("おやすみなさいませ、<@#{data.user}>さま")
    end

    case rand(100)
    when 99
      param = makeParam("#{data.text}とはなんですか？")
    end

    # ---------------------------
    # docomo の雑談API
    # ---------------------------
    if data.text =~ /^[dｄ] (.*)/
      resp = @responder_DocomoAPI.response($1, @context)
      param = makeParam(resp["message"])
      @context = resp["context"] if resp["context"] != nil
      puts @context
    end

    # --------------------------
    # paramに発言内容とチャンネルが入っているので
    # 投稿
    @slack_client.message(param) if param != nil
  end
end
