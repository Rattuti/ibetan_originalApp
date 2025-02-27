class MessagesController < ApplicationController
    #skip_before_action :verify_authenticity_token, only: [:create] # 必要なアクションに対してのみ無効化
    #before_action :authenticate_user!, only: ["index"]

    def index
        messages = Message.includes(:user, likes: :user).all
        messages_array = messages.map do |message|
            {
                id: message.id,
                user_id: message.user.id,
                name: message.user.name,
                content: message.content,
                email: message.user.email,
                created_at: message.created_at,
                likes: message.likes.map{
                    |like| {
                        id: like.id,
                        email: like.user.email
                    }
                }
            }
        end
        render json: messages_array, status: :ok

    end

    def create
        user = User.find_by(email: params[:email])
        message = Message.find_by(id: params[:message_id])
    
        if user.nil? || message.nil?
            render json: { success: false, error: "User or Message not found" }, status: :not_found
            return
        end

        like = user.likes.build(message: message)
        if like.save
            render json: { success: true, id: like.id, email: like.user.email }, status: :created
        else
            render json: { success: false, errors: like.errors.full_messages }, status: :unprocessable_entity
        end
    end

end
