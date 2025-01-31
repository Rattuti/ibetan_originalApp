#webに接続するためのライブラリ
require "open-uri"
#クレイピングに使用するライブラリ
require "nokogiri"

# スクレイピング対象のURL
url = "https://www.sejuku.net/blog/"
#取得するhtml用charset
charset = nil

html = URI.open(url) do |page|
    #読み込み先のサイトの負荷を小さくするため、読み込みの間隔を作った
    sleep rand(1.5..3.0)
    #charsetを自動で読み込み、取得
    charset = page.charset
    #htmlを読み込み、変数pageに変数htmlに渡す
    page.read
end

# htmlを分析してdocオブジェクトを作る
# 分析＝パースのため、Nokogiri で切り分け
doc = Nokogiri::HTML.parse(html, nil, charset)

puts doc.css('h5').text.strip