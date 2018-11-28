# 辞書クラス
# random : ランダムに返す
class Dictionary
  DIC_RANDOM = "./dics/random.txt"
  DIC_PATTERN = "./dics/pattern.txt"
  attr_reader :random, :pattern

  # 初期化時にえいやっと読み込む
  def initialize
    # random辞書読み込み
    @random = []
    open(DIC_RANDOM).each_line do |line|
      @random << line.chomp if !line.nil?
    end
    warn "random loaded."

    # load pattern dic
    @pattern = []
    open(DIC_PATTERN).each_line do |line|
      patterns, phrases = line.chomp.split("\t")
      next if patterns.nil? or phrases.nil?
      @pattern << PatternItem.new(patterns, phrases)
    end
    warn "pattern loaded."
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
    # pettern辞書書き出し
    open(DIC_PATTERN, 'w') do |f|
      @pattern.each do |ptn_item|
        f.puts(ptn_item.make_line)
      end
    end
  end

end

class PatternItem
  def initialize(pattern, phrases)
    pair = pattern.split(":", 2)
    if pair.size == 2
      @modify = pair[0].to_f
      @pattern = Regexp.compile(pair[1])
    else
      @pattern = Regexp.compile(pair[0])
    end

    @phrases = phrases.split("|").map{ |phrase|
      pair = phrase.split(":")
      if pair.size == 2
        { "need" => pair[0].to_f, "phrase" => pair[1] }
      else
        { "need" => 0.0, "phrase" => pair[0] }
      end
    }
  end

  def match(str)
    return str.match(@pattern)
  end

  def select_random(ary)
    return ary[rand(ary.size)]
  end

  def add_phrase(phrase)
    return if @phrases.find {|p| p["phrase"] == phrase }
    @phrase.push({"need" => 0, "phrase" => phrase})
  end

  def make_line
    pattern = "#{@modify.to_f}:#{@pattern}"
    phrases = @phrases.map{ |p| "#{p["need"].to_f}:#{p["phrase"]}" }
    return pattern + "\t" + phrases.join("|")
  end

  def choice(mood)
    choices = []
    @phrases.each do |p|
      choices.push(p['phrase']) if suitable?(p['need'], mood)
    end
    return (choices.empty?)? nil : select_random(choices)
  end

  def suitable?(need, mood)
    return true if need == 0
    if need > 0
      return mood > need
    else
      return mood < need
    end
  end

  def select_random(ary)
    return ary[rand(ary.size)]
  end
end
