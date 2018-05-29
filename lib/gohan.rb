# ごはん記録・管理システム
# そのうち栄養管理とかもしたい

GOHAN_DIR = "./data/gohan"
def gohanCheck(data)
  # 保存用ファイルが無ければ作る
  file_path = "#{GOHAN_DIR}/" + Time.now.strftime("%Y.%m.%d") + ".txt"
  open(file_path).close if File.exists?(file_path)

  nowHour = Time.now.hour

  hitokoto = ""
  if nowHour >= 5 && nowHour <= 9
    # 朝ごはんかな？
    hitokoto = "朝ごはんですね。"
  elsif nowHour >= 10 && nowHour <= 11
    # 朝にしてはちょっと遅いですよ
    hitokoto = "朝ごはんにしてはちょっと遅いですね......。"
  elsif nowHour >= 12 && nowHour <= 13
    # 昼ごはんかな？
    hitokoto = "昼ごはんですね！"
  elsif nowHour >= 14 && nowHour <= 16
    # 間食ですか？
    hitokoto = "おやおや、間食ですか～？"
  elsif nowHour >= 17 && nowHour <= 21
    # 夕ごはんかな？
    hitokoto = "晩ごはんですね～"
  elsif nowHour >= 22
    # 遅いのでアウト
    hitokoto = "こんな時間に食べるなんて！許しませんよ！！"
  end

  # ごはん部分取り出し
  # ごはん:ほげ、ふが で書く
  gohan = data.text.gsub(/ごはん:/, "")

  # 保存
  open(file_path, "a") do |f|
    tmp = Time.now.strftime("%H:%M") + "," + gohan
    f.puts(tmp)
  end

  response = hitokoto + "#{gohan}を食べたこと、保存しました。"
end

