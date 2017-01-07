require 'net/https'
require 'json'

module DocomoDialog
  BASE_URL = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?'
  api_key = open("/home/jf712/.docomo/ako").read.split("\n")[0]

  def Post(message, context="", nickname="", nickname_v="", sex="", bloodtype="", birthdateY="", birthdateM="", birthdateD="", age="", constellations="", mode="", t="")
    uri = URI.parse(BASE_URL + "APIKEY=" + api_key)
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

    req.body = data.to_json
    res = https.request(req)
  end

  module_function :Post
end

