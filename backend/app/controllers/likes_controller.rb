class LikesController < ApplicationController
#    before_action :authenticate_user!

    def create
    like = current_user.likes.new(message_id: params[:message_id])
        if like.save
            render json: { 
                success: true,
                id: like.id,
                email: like.user.email
            }, status: :created
        else
            render json: {
                success: false,
                errors: like.errors.full_messages
            }, status: :unprocessable_entity
        end
    end

    def destroy
    like = current_user.likes.find_by(message_id: params[:message_id])
        if like
            like.destroy
            render json: {
                success: true
            }, status: :ok
        else
            render json: { 
                success: false,
                error: "Like not found"
            }, status: :not_found
        end
    end
end

