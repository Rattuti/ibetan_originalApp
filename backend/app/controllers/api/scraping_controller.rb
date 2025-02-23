module Api
    class ScrapingController < ApplicationController
        before_action :debug_headers

        def debug_headers
            Rails.logger.debug "🔍 Authorization: #{request.headers['Authorization']}"
            Rails.logger.debug "🔍 client: #{request.headers['client']}"
            Rails.logger.debug "🔍 uid: #{request.headers['uid']}"
        end

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
