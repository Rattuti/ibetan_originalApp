class RoomChannel < ApplicationCable::Channel
    def subscribed
        stream_from "room_channel_#{current_user.id}"
        Rails.logger.info "✅ RoomChannel に接続しました (User: #{current_user.email})"
        stream_from "message_#{params[:message_id]}"
    end

    def receive(data)
        unless current_user
            Rails.logger.error "❌ current_user が nil です"
            return 
        end

        Rails.logger.debug "📩 受信データ: #{data}"

        content = data["message"].is_a?(Hash) ? data["message"]["text"] : data["message"]
        if content.blank?
            Rails.logger.error "❌ メッセージが空のため、保存をスキップ"
        return
    end

    message = current_user.messages.create(content: content)

    if message.persisted?
        broadcast_data = {
            id: message.id,
            user_id: message.user.id,
            name: message.user.name,
            nickname: message.user.nickname,
            content: message.content,
            created_at: message.created_at,
            email: message.user.email
        }

        Rails.logger.debug "🚀 ブロードキャストするデータ: #{broadcast_data}"
        ActionCable.server.broadcast("room_channel_#{current_user.id}", broadcast_data)
    else
        Rails.logger.error "❌ メッセージの保存に失敗しました"
    end
    end
end
