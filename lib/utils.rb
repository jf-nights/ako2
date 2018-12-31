# チャンエル
SECRET_MEMO = "C9PDZET9V"
REIANKYO = "C03ANSF4X"
DOKO = "CB8CHL7CM"
TEST = "GEPND1JG2"

# なんかいろいろ使い回しそうな関数
def makeParam(text, channel="C9PDZET9V")
  params = {
    text: text,
    channel: channel,
  }
  return params
end

# WebAPIを使って発言
# こっちの方がオプション増える気がする
def postByWebAPI(client, text, channel)
  client.chat_postMessage(
    text: text,
    channel: channel,
    as_user: true,
    user_name: "ako",
    icon_emoji: "ako",
    link_names: true
  )
end
