# 辞書クラス
# random : ランダムに返す
class Dictionary
  DIC_RANDOM = "./dics/random.txt"
  attr_reader :random

  # 初期化時にえいやっと読み込む
  def initialize
    # random辞書読み込み
    @random = []
    open(DIC_RANDOM).each_line do |line|
      @random << line.chomp if !line.nil?
    end
    warn "random loaded."
  end


  # 外から呼ぶ
  def study(text)
    study_random(text)
  end

  # randomというか、全発言を保存してるだけ
  def study_random(text)
    @random << text if !@random.include?(text)
  end

  # 定期的にファイルに書き出し
  # cronで呼ぶ？
  def save
    # random辞書書き出し
    open(DIC_RANDOM, 'w') do |f|
      f.puts(@random)
    end
  end

end
