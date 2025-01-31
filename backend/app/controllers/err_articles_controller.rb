class ArticlesController < ApplicationController
    BASE_URL = "https://www.city.suita.osaka.jp/kurashi/1018573/1018587/index.html".freeze

    def index
        articles = scrape_articles
        render json: articles, status: :ok
    rescue StandardError => e
        Rails.logger.error "エラーが発生しました: #{e.message}"
        render json: { error: "エラーが発生しました: #{e.message}" }, status: :internal_server_error
    end

    private

    def scrape_articles
        articles_array = []
        agent = Mechanize.new
        page = agent.get(BASE_URL)

        page.search('li.box a').uniq.each do |element|
        title, url = extract_article_details(element)
        next unless title && url
        next if Article.exists?(title: title, url: url)

        new_article = save_article(title, url)
        articles_array << { 
            id: new_article.id,
            title: new_article.title,
            url: new_article.url
        }
        notify_clients(new_article)
        end

        articles_array
    end

    def extract_article_details(element)
        title = element.text.strip
        href = element['href']
        return nil, nil if href.blank?

        url = URI.join(BASE_URL, href).to_s
        [title, url]
    end

    def save_article(title, url)
        Article.create!(
        title: title,
        url: url,
        favorites: []
        ).tap do |article|
        article.set_article_id
        article.save!
        end
    end

end
