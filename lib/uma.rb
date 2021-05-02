require 'mechanize'

#page = agent.get("https://www.jbis.or.jp/horse/0001236410/")

def get_pedigree(horse)
  agent = Mechanize.new

  # 引数のウマをsjisにして検索
  "------------------------------------"
  pp horse
  uma = URI.encode_www_form_component(horse, "sjis")
  url = "https://www.jbis.or.jp/horse/result/?entry=entry_1&sid=result&keyword=#{uma}&x=75&y=12"
  page = agent.get(url)

  # 返す結果
  pedigree = {}

  begin
    href = page.search(".cell-br-no a").attr("href").value
  rescue
    pedigree.store(horse, "search error")
  end

  if href != nil
    begin
      # 該当ウマのページへ
      url = "https://www.jbis.or.jp" + href
      page = agent.get(url)
      # 親
      th = page.search(".tbl-pedigree-01 th")
      # 祖父母
      td = page.search(".tbl-pedigree-01 td")

      # エラー処理とかなんもかいてない
      pedigree.store("father", th[0].text.gsub("\r\n", ""))
      pedigree.store("mother", th[1].text.gsub("\r\n", ""))
      pedigree.store("fa_grandpa", td[0].text.gsub("\r\n", ""))
      pedigree.store("fa_grandma", td[1].text.gsub("\r\n", ""))
      pedigree.store("ma_grandpa", td[2].text.gsub("\r\n", ""))
      pedigree.store("ma_grandma", td[3].text.gsub("\r\n", ""))
    rescue
      pedigree.store(horse, "parent error")
    end
  end

  return pedigree
end
