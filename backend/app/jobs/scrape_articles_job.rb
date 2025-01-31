class ScrapeArticlesJob < ApplicationJob
    queue_as :default
  
    def perform
      ArticleScraper.scrape_and_save
    rescue StandardError => e
      Rails.logger.error "ジョブ内エラー: #{e.message}"
    end
  end
  