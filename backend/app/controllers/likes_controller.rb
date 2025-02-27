class LikesController < ApplicationController
    def create
    user = User.find_by(email: params[:email])
    message = Message.find_by(id: params[:message_id])

    if user.nil? || message.nil?
        render json: { success: false, error: "User or Message not found" }, status: :not_found
        return
    end

    like = user.likes.new(message: message)
    if like.save
        render json: { success: true, id: like.id, email: like.user.email }, status: :created
    else
        render json: { success: false, errors: like.errors.full_messages }, status: :unprocessable_entity
    end
    end

    def destroy
    like = Like.find_by(id: params[:id], user_id: params[:user_id])
    
    if like.nil?
        render json: { success: false, error: "Like not found" }, status: :not_found
        return
    end

    if like.destroy
        render json: { success: true }, status: :ok
    else
        render json: { success: false, errors: like.errors.full_messages }, status: :unprocessable_entity
    end
    end
end
