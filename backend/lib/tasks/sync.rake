namespace :sync do
    task feeds: [:environment] do
        Feed.all.each do |feed|
            xml = HTTParty.get(feed.url).body
            rss = Feedjira.parse xml
            rss.articles.each do |articule|
                local_article = feed.articles.where(title: article.title).first_or_initialize
                local_article.update_attributes(content: article.content, author: article.author, url: article.url, published: article.published)
                p "Synced Article - #{article.title}"
            end
        p "Synced Feed - #{feed.name}"
        end
    end
end