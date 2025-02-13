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
        content: event_details[:content] # <p>要素の保存
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
              start_date: date,
              end_date: date,
              color: article.color
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
          start_date: default_date,
          end_date: default_date,
          color: article.color
        )
        events << event
      end
    end

    { articles: articles, events: events }
  end

  # 記事の詳細ページから情報をスクレイピングするメソッド
  def self.scrape_event_details(agent, url)
    detail_page = agent.get(url)
    fields_to_scrape = %w[開催日 費用 保育] # スクレイピング対象のフィールド

    event_details = {}
    fields_to_scrape.each do |field|
      value = detail_page.search("dl dt:contains('#{field}') + dd").text.strip
      event_details[field.to_sym] = value if value.present?
    end

    
    # `p.ecategory` の次の `p` を取得
    ecategory_p = detail_page.at('p.ecategory') # `<p class="ecategory">` を取得
    if ecategory_p
      next_p = ecategory_p.next_element # `p.ecategory` の次の要素を取得
      if next_p&.name == 'p' # 次の要素が `p` なら取得
        puts "取得したp要素: #{next_p}" if next_p
        puts "取得したpのテキスト: #{next_p.text.strip}" if next_p
        event_details[:summary] = next_p.text.strip
      end
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
