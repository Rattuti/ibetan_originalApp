class MessagesController < ApplicationController
    before_action :authenticate_user!, only: ["index"]

    def index
        messages = Message.all
        messages_array = messages.map do |message|
            {
                id: message.id,
                user_id: message.user.id,
                name: message.user.name,
                content: message.content,
                email: message.user.email,
                created_at: message.created_at,
                favorites: message.favorites.map{ |favorite| {id: favorite.id, email: favorite.user.email} }
            }
        end
    
        render json: messages_array, status: 200
    
    end

end
