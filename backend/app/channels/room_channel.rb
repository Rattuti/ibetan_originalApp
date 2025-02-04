class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    user = User.find_by(email: data['email'])
    
    unless user
      Rails.logger.error "User not found for email: #{data['email']}"
      return
    end

    if message = Message.create(content: data['message'], user_id: user.id)
      ActionCable.server.broadcast 'room_channel', {
        message: data['message'], 
        name: user.name, 
        created_at: message.created_at
      }
    else
      Rails.logger.error "Failed to save message: #{message.errors.full_messages.join(', ')}"
    end
  end

end
