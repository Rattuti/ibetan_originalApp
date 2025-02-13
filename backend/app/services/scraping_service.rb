class ScrapingService
  require 'mechanize'
  require 'date'

  # スクレイピング対象のベースURL
  BASE_URL = "https://www.city.suita.osaka.jp/kurashi/1018573/1018587/index.html"

  # ランダムな色を返すメソッド
  def self.random_color
    colors = ['#FF5733', '#33FF57', '#3357FF', '#FF33A5', '#A533FF']
    colors.sample
  end

  # 記事とイベントをスクレイピングするメソッド
  def self.scrape_articles
    agent = Mechanize.new
    page = agent.get(BASE_URL)

    articles = []
    events = []
    elements = page.search('li.box a') # 記事のリンクを取得

    elements.each do |element|
      title = element.text.strip # 記事のタイトルを取得
      href = element['href'] # 記事のURLを取得
      url = URI.join(BASE_URL, href).to_s # 相対URLを絶対URLに変換

      # next if Article.exists?(url: url)

      event_details = scrape_event_details(agent, url)
      event_dates = convert_to_date_format(event_details[:開催日])

      # 記事を作成し、保存
      article = Article.create!(
        title: title,
        url: url,
        color: random_color,
        event_dates: event_dates.any? ? event_dates.join(', ') : nil,
        cost: event_details[:費用],
        childcare: event_details[:保育],
        content: event_details[:summary] # <p>要素の保存
      )

      # 保存された後にarticle_idを自身のidで更新
      article.update!(article_id: article.id)

      articles << article

      # イベント情報の作成
      if article.persisted? && event_dates.any?
        event_dates.each do |date|
          begin
            event = Event.create!(
              article_id: article.article_id,
              title: article.title,
              content: article.content,
              start_date: date,
              end_date: date,
              color: article.color,
              judge: true
            )
            events << event
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error "Event保存エラー: #{e.message} - article_id: #{article.id}, dates: #{event_dates}"
          end
        end
      elsif article.persisted?
        # 開催日がない場合は、今日の日付を設定
        default_date = Date.today.strftime("%Y-%m-%d")
        event = Event.create!(
          article_id: article.article_id,
          title: article.title,
          content: article.content,
          start_date: default_date,
          end_date: default_date,
          color: article.color,
          judge: true
        )
        events << event
      end
    end

    { articles: articles, events: events }
  end

  # 記事の詳細ページから情報をスクレイピングするメソッド
  def self.scrape_event_details(agent, url)
    detail_page = agent.get(url)
  
    event_details = {}
  
    # `p.ecategory` を取得
    ecategory_p = detail_page.at('p.ecategory')
  
    unless ecategory_p
      puts "デバッグ: <p class='ecategory'> が見つかりませんでした。"
      return event_details
    end
  
    # `p.ecategory` の次のすべての要素を取得
    following_elements = ecategory_p.xpath("following-sibling::*")
    puts "デバッグ: `p.ecategory` の次の要素一覧: #{following_elements.map(&:name).join(', ')}"
  
    # `<ul class="objectlink">` を探す
    objectlink_ul = detail_page.at('ul.objectlink')
  
    if objectlink_ul
      puts "デバッグ: <ul class='objectlink'> が見つかりました。"
      # `ul.objectlink` の直前の `<p>` 要素を取得
      filtered_ps = []
      objectlink_ul.xpath("preceding-sibling::*").reverse_each do |el|
        break unless el.name == "p"  # <p> 以外のタグが来たら停止
        filtered_ps << el
      end
      filtered_ps.reverse!  # 元の順序に戻す
    else
      puts "デバッグ: <ul class='objectlink'> が見つかりませんでした。"
      # `ul.objectlink` がない場合は `p.ecategory` の後のすべての `<p>` を取得
      filtered_ps = ecategory_p.xpath("following-sibling::p")
    end
  
    if filtered_ps.any?
      all_text = filtered_ps.map { |el| el.inner_html.strip.gsub("<br>", "\n") }.join("\n")
      puts "デバッグ: 取得した <p> 要素:\n#{all_text}"
      event_details[:summary] = all_text.presence || ""
    else
      puts "デバッグ: <p> 要素が見つかりませんでした。"
      event_details[:summary] = "" # `nil` を防ぐため空文字をセット
    end

    # 他の情報（開催日・費用・保育）を取得
    fields_to_scrape = %w[開催日 費用 保育]
    fields_to_scrape.each do |field|
      value = detail_page.search("dl dt:contains('#{field}') + dd").text.strip
      event_details[field.to_sym] = value if value.present?
    end
  
    event_details
  end

  # 「開催日」をDate形式に変換するメソッド
  def self.convert_to_date_format(dates_string)
    return [] if dates_string.blank?

    dates = dates_string.split('、') # 「、」で区切られた日付を分割
    dates.map do |date|
      month_day = date.strip
      month, day = month_day.scan(/\d+/) # 月と日を取得
      current_year = Date.today.year # 現在の年を取得
      begin
        formatted_date = Date.new(current_year, month.to_i, day.to_i) # Date オブジェクトを作成
        formatted_date.strftime("%Y-%m-%d")
      rescue ArgumentError => e
        Rails.logger.error "日付変換エラー: #{e.message}"
        nil
      end
    end.compact # nilを取り除く
  end

  # 既存の記事を取得し、お気に入りのクリック数を含めて返すメソッド
  def self.fetch_existing_articles
    Article.left_joins(:favorites).select(
      'articles.*, COALESCE(favorites.click, 0) AS click'
    ).map do |article|
      {
        id: article.id,
        title: article.title,
        url: article.url,
        color: article.color,
        click: article.click || 0 # click が nil の場合は 0 にする
      }
    end
  end
end
