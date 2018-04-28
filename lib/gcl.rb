require 'google/cloud/language'

# ----------------------------
# Google Cloud Language の機能利用
# ----------------------------
module GCL
  def init
    @language = Google::Cloud::Language.new
  end

  def getScore(text)
    response = @language.analyze_sentiment(content: text, type: :PLAIN_TEXT)
    sentiment = response.document_sentiment
    return [sentiment.score, sentiment.magnitude]
  end

  module_function :init, :getScore
end


