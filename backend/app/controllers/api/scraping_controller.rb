module Api
    class ScrapingController < ApplicationController
        def index
            articles = ScrapingService.fetch_existing_articles
            Rails.logger.info "取得した記事データ: #{articles}"
            render json: { articles: articles }, status: :ok
        rescue StandardError => e
            Rails.logger.error "エラーが発生しました: #{e.message}"
            render json: { error: "エラーが発生しました: #{e.message}" }, status: :internal_server_error
        end
    end
end
