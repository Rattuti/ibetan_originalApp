class ScrapingService
  require 'mechanize'
  require 'date'

  BASE_URL = "https://www.city.suita.osaka.jp/kurashi/1018573/1018587/index.html"

  def self.random_color
    colors = ['#FF5733', '#33FF57', '#3357FF', '#FF33A5', '#A533FF']
    colors.sample
  end

  def self.scrape_articles
    agent = Mechanize.new
    page = agent.get(BASE_URL)

    articles = []
    events = []
    elements = page.search('li.box a')

    elements.each do |element|
      title = element.text.strip
      href = element['href']
      url = URI.join(BASE_URL, href).to_s

      next if Article.exists?(url: url)

      event_details = scrape_event_details(agent, url)
      event_dates = convert_to_date_format(event_details[:開催日])

      # 記事を作成し、保存
      article = Article.create!(
        title: title,
        url: url,
        color: random_color,
        event_dates: event_dates.any? ? event_dates.join(', ') : nil,
        cost: event_details[:費用],
        childcare: event_details[:保育]
      )

      # 保存された後にarticle_idを自身のidで更新
      article.update!(article_id: article.id)

      articles << article

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

  def self.scrape_event_details(agent, url)
    detail_page = agent.get(url)
    fields_to_scrape = %w[開催日 費用 保育]

    event_details = {}
    fields_to_scrape.each do |field|
      value = detail_page.search("dl dt:contains('#{field}') + dd").text.strip
      event_details[field.to_sym] = value if value.present?
    end

    event_details
  end

  def self.convert_to_date_format(dates_string)
    return [] if dates_string.blank?

    dates = dates_string.split('、')
    dates.map do |date|
      month_day = date.strip
      month, day = month_day.scan(/\d+/)
      current_year = Date.today.year
      begin
        formatted_date = Date.new(current_year, month.to_i, day.to_i)
        formatted_date.strftime("%Y-%m-%d")
      rescue ArgumentError => e
        Rails.logger.error "日付変換エラー: #{e.message}"
        nil
      end
    end.compact
  end

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
