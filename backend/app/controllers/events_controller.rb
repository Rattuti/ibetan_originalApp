class EventsController < ApplicationController
    def index
        @events = Event.all
        render json: @events
    end

    def create
        @event = Event.new(event_params)
        if @event.save
            render json: @event, status: :created
        else
            render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    # 既存イベントの更新
    def update
        @event = Event.find(params[:id])
        if @event.update(event_params)
            render json: @event
        else
            render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        event = Event.find_by(id: params[:id])

        if event
            event.destroy
            render json: { message: 'Event deleted' }, status: :ok
        else
            render json: { error: 'Event not found' }, status: :not_found
        end
    end
    
    private
    
    # イベントパラメータを設定
    def event_params
        params.require(:event).permit(:article_id, :title, :start_date, :end_date, :color)
    end
end
