require_relative './lib/utils'
require_relative './lib/gohan'
require_relative './lib/omikuji'
require_relative './lib/get_channels'
require_relative './responder'
require_relative './dictionary'
require_relative './lib/morph'

# 阿古さん本体
class Ako
  def initialize(slack_client, web_client)
    @slack_client = slack_client
    @web_client = web_client
    @context = ""
    Morph::init_analyzer

    # dictionary
    @dictionary = Dictionary.new
    # responder
    @responder_What = WhatResponder.new(@dictionary)
    @responder_Random = RandomResponder.new(@dictionary)
    @responder_Pattern = PatternResponder.new(@dictionary)

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
    # 反応する機構
    responder = nil
    # 発言すべき内容とチャンネルの入れもの
    param = nil
    # -----------------------
    # @responderを決める処理
    # @responder = hoge
    # response = @responder.response
    # @slack_client.message(response) if response != nil
    # という形にしたい

    # ---------------------------
    # 「おやすみなさい」
    # ---------------------------
    if data.text == "おやすみなさい"
      param = makeParam("おやすみなさいませ、<@#{data.user}>さま", data.channel)

    elsif data.text =~ /どこやっけ/  && data.channel == DOKO
      # #どこやっけ
      message = "ここじゃないですか？ ##{select_channel}"
      postByWebAPI(@web_client, message, DOKO)
      # --------------------------
      # 僕からの発言で特別に扱いたいとき
    elsif data.user == "U035ULAP5" && data.channel == REIANKYO
      # ごはん保存
      if data.text =~ /ごはん:/
        res = gohanCheck(data)
        param = makeParam(res, REIANKYO)
      end

      # 発言内容など覚えたことをファイル書き出し
      if data.text =~ /^save$/
        save()
      end

    else
      if data.channel == SECRET_MEMO || data.channel == TEST
        if data.text =~ /^(omikuji|おみくじ)$/
          message = run_omikuji(data.user)
          postByWebAPI(@web_client, message, data.channel)
        else
          puts data.user

          case rand(100)
          when 0
            responder = @responder_What
          when 1..50
            responder = @responder_Random
          when 51..99
            responder = @responder_Pattern
          end


          # これ以降のstudy, responderに必要な
          parts = Morph::analyze(data.text)
          # --------------------------
          # 発言内容を覚える ...oO(<= "覚える" とは......?)
          # この時点では起動してるメモリ上に乗っているだけなので、
          # 何かしらの手段で @dictionary#save を呼ぶ必要がある...
          @dictionary.study(data.text, parts)

          # --------------------------
          # 今回のreponderで返答作成
          res = responder.response(data.text, parts, 0.0)
          puts res

          # --------------------------
          # paramに発言内容とチャンネルが入っているので投稿
          param = makeParam(res, data.channel) if res != nil
          @slack_client.message(param) if param != nil
        end

      end
    end


  end

  def save
    @dictionary.save
  end
end
