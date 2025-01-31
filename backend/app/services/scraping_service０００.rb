class ScrapingService
  require 'mechanize'
  require 'date'

  BASE_URL = "https://www.city.suita.osaka.jp/kurashi/1018573/1018587/index.html".freeze

  def self.scrape_articles
    agent = Mechanize.new
    articles_array = []

    begin
      page = agent.get(BASE_URL)
      Rails.logger.info "ページ取得成功: #{BASE_URL}"
    rescue Mechanize::ResponseCodeError => e
      Rails.logger.error "ページ取得失敗: #{e.message}"
      return []
    end

    elements = page.search('li.box a')
    Rails.logger.info "取得した要素数: #{elements.size}"

    elements.uniq.each do |element|
      title, url = extract_article_details(element)
      next unless title && url

      new_article = save_article(title, url)
      if new_article
        Rails.logger.info "保存済み記事: #{new_article.id}, #{new_article.title}"
        articles_array << {
          id: new_article.id,
          title: new_article.title,
          url: new_article.url
        }
      end
    end

    articles_array
  end

  def self.extract_article_details(element)
    title = element.text.strip
    href = element['href']
    return nil, nil if href.blank?

    url = URI.join(BASE_URL, href).to_s
    Rails.logger.info "記事抽出: title=#{title}, url=#{url}"
    [title, url]
  end

  def self.save_article(title, url)
    existing_article = Article.find_by(url: url)
    return existing_article if existing_article

    article = Article.new(
      title: title,
      url: url,
      article_id: next_article_id,
      favorites: []
    )

    if article.save
      article
    else
      Rails.logger.error "記事保存失敗: #{article.errors.full_messages.join(', ')}"
      nil
    end
  end

  def self.next_article_id
    Article.maximum(:article_id).to_i + 1
  end
end
