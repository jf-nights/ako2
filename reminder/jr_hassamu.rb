# ジェイ・アール生鮮市場 発寒店
# http://jr-seisen.jp/hassamu/ の最新チラシ情報
require_relative './post_to_slack'

SITE_URL = "http://jr-seisen.jp/hassamu/"
agent = Mechanize.new

agent.get(SITE_URL)
chirashi_url = agent.page.search("//*[@id='specpagewidgets-10']/p/a").first[:href]


SlackLib.postMessage("チラシ情報です")
SlackLib.postMessage(chirashi_url)

