require 'net/https'
require 'cgi'
require 'json'
require 'addressable/uri'

module DocomoAPI
  DIALOGE_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?'
  QA_URL = 'https://api.apigw.smt.docomo.ne.jp/knowledgeQA/v1/ask?'
  API_KEY = open("/home/jf712/.docomo/ako").read.split("\n")[0]

  def post(message, context="", nickname="", nickname_v="", sex="", bloodtype="", birthdateY="", birthdateM="", birthdateD="", age="", constellations="", mode="", t="")
    uri = URI.parse(DIALOGE_URL + "APIKEY=" + API_KEY)
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"

    data = {
      "utt" => message,
      "context" =>  context,
      "nickname" => nickname,
      "nickname_v" => nickname_v,
      "sex" => sex,
      "bloodtype" => bloodtype,
      "birthdateY" => birthdateY,
      "birthdateM" => birthdateM,
      "birthdateD" => birthdateD,
      "age" => age,
      "constellations" => constellations,
      "mode" => mode,
      "t" => t 
    }

    # jsonにしとかないと怒られる
    req.body = data.to_json
    res = https.request(req)

    body = JSON.parse(res.body)

    if res.code == "200"
      return body
    else
      return res.body
    end
  end

  def postQA(message)
    uri = Addressable::URI.parse(QA_URL + "q=" + CGI.escape(message) + "&APIKEY=" + API_KEY)
    res = JSON.parse(Net::HTTP.get(uri))
    puts res

    if res["code"] =~ /^S.*/
      # 回答アリ
      return res["message"]["textForDisplay"]
    else
      if res["requestError"] == nil
        # 回答ナシ
        return res["message"]
      else
        # そもそもエラー
        return res
      end
    end

  end

  module_function :post, :postQA
end
