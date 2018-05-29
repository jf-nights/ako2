require 'google/cloud/language'
require_relative './lib/utils'
require_relative './lib/gcl'
require_relative './lib/gohan'
require_relative './responder'
require_relative './dictionary'

# 阿古さん本体
class Ako
  def initialize(slack_client)
    @slack_client = slack_client
    @context = ""

    # Google Cloud Language
    GCL.init
    # respnoder
    @responder_DocomoAPI = DocomoResponder.new
    # dictionary
    @dictionary = Dictionary.new

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
      param = makeParam("おやすみなさいませ、<@#{data.user}>さま", data.channel)
    end

=begin
    gclResult = GCL.getScore(data.text)
    score, magnitude = gclResult[0], gclResult[1]
    param = makeParam("Score : #{score}, Magnitude : #{magnitude} です")
=end

    case rand(100)
    when 0
      param = makeParam("#{data.text}とはなんですか？", data.channel)
    when 1..99
      param = makeParam(@dictionary.random[rand(@dictionary.random.size)], data.channel)
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
    # 発言内容を覚える ...oO(<= "覚える" とは......?)
    # この時点では起動してるメモリ上に乗っているだけなので、
    # 何かしらの手段で @dictionary#save を呼ぶ必要がある...
    @dictionary.study

    # --------------------------
    # 僕からの発言で特別に扱いたいとき
    if data.user == "U035ULAP5"
      # ごはん保存
      if data.text =~ /ごはん:/
        res = gohanCheck(data)
        param = makeParam(res, REIANKYO)
      end

      # 発言内容など覚えたことをファイル書き出し
      if data.text =~ /^save$/
        @dictionary.save
      end
    end


    # --------------------------
    # paramに発言内容とチャンネルが入っているので
    # 投稿
    @slack_client.message(param) if param != nil
  end
end
