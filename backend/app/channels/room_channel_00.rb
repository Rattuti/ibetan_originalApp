class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{current_user.id}"
  end

  # チャネルの接続が切断されたときに呼ばれる
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージが送信されたときに呼ばれる
  def receive(data)
    # ユーザーがログインしていない場合は処理を中断
    return unless current_user
    

    # 受信したデータをJSONに変換
    json_content = data["message"].is_a?(String) ? JSON.parse(data["message"]) : data["message"]
    
    # メッセージが適切にパースされていることを確認する
    content = json_content["message"] || json_content

    # 受け取ったメッセージデータを基に、新しいメッセージを作成
    message = current_user.messages.create(content: content)

    # 受け取ったメッセージデータを基に、新しいメッセージを作成
    message = current_user.messages.create(content: json_content)
    
    if message.persisted?
      ActionCable.server.broadcast("room_channel_#{current_user.id}", {
        id: message.id,
        user_id: message.user.id,
        name: message.user.name,
        content: message.content,
        created_at: message.created_at,
        email: message.user.email
      })
    end
  end
end
