class LikesController < ApplicationController
#    before_action :authenticate_user!

    def create
    user = User.find_by(email: params[:email])
    if user.nil?
        render json: { success: false, error: "User not found" }, status: :not_found
        return
    end
    puts "User found: #{user.name}"

    like = user.likes.new(message_id: params[:message_id])
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
    like = user.likes.find_by(message_id: params[:message_id])
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

