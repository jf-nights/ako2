require 'slack-ruby-client'

class Ako
  def initialize(client)
    @client = client
  end

  # メッセージを受け取る
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
      params = {
        channel: "C9PDZET9V",
        text: "おやすみなさいませ"
      }
      @client.message(params)
    end
  end
end
