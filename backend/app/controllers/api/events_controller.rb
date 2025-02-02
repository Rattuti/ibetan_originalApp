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
        # article_id を基に Article を取得
            article = Article.find_by(id: event.article_id)
            if article
                # article の cost をイベント詳細に追加
                event_data = {
                    id: event.id,
                    name: event.title,
                    start: event.start_date,
                    end: event.end_date,
                    color: event.color,
                    url: article.url,
                    cost: article.cost,  # article の cost を追加
                    childcare: article.childcare
                }
                render json: event_data
            end # article if
        else
            render json: { error: "イベントが見つかりません", id: params[:id] }, status: :not_found
        end # event if
    end

    def create
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
        params.require(:event).permit(:title, :start_date, :end_date, :color)
    end
end
