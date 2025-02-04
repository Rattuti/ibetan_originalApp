class Api::EventsController < ApplicationController
    def index
        @events = Event.all
        render json: @events.map {
        |event| 
            {
                id: event.id,
                name: event.title,
                start: event.start_date, 
                end: event.end_date,
                color: event.color
            }
        }
    end

    def show
        puts "受け取ったID: #{params[:id]}" # 確認用ログ

        event = Event.find_by(id: params[:id]) # ID に対応するイベントを取得
        if event
            if event.article_id.present?
            # 記事情報を取得するかどうかで場合分け
                article = Article.find_by(id: event.article_id)
                if article
                    event_data = {
                        id: event.id,
                        name: event.title,
                        start: event.start_date,
                        end: event.end_date,
                        color: event.color,
                        url: article.url,
                        cost: article.cost,
                        childcare: article.childcare
                    }
                else
                    event_data = { error: "該当する記事が見つかりません", id: params[:id] }
                end
            else
                event_data = {
                    id: event.id,
                    name: event.title,
                    start: event.start_date,
                    end: event.end_date,
                    color: event.color
                }
            end
            render json: event_data
        else
            render json: { error: "イベントが見つかりません", id: params[:id] }, status: :not_found
        end
    end

    def create
        puts params.inspect  # 受け取ったパラメータのログ

        event = Event.new(event_params)
        if event.save
            render json: {
                id: event.id,
                name: event.title,
                start: event.start_date,
                end: event.end_date,
                color: event.color
            }, status: :created
        else
            puts event.errors.full_messages
            render json: event.errors, status: :unprocessable_entity
        end
    end

    def destroy
        event = Event.find(params[:id])
        event.destroy
        render json: { message: 'Event deleted' }
    end

    private

    def event_params
        params.require(:event).permit(:article_id, :title, :start_date, :end_date, :color)
    end
end
