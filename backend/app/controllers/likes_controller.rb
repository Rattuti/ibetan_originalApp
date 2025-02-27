class LikesController < ApplicationController
    def create
        # current_userがnilの場合のエラーハンドリング
        if current_user.nil?
            return render json: { error: "ユーザーが認証されていません" }, status: :unauthorized
        end

        message = Message.find_by(id: params[:message_id])
        puts "DEBUG: message -> #{message.inspect}"
        puts "DEBUG: params -> #{params.inspect}"

        return render json: { error: "Message not found" }, status: :not_found unless message

        like = current_user.likes.find_or_initialize_by(message_id: message.id)

        like.click = like.click == 1 ? 0 : 1
        like.mark_type = params[:mark_type]

        if like.save
            render json: { id: like.id, click: like.click, mark_type: like.mark_type }, status: :created
        else
            render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
            like = Like.find_by(id: params[:id], user_id: current_user.id)
        return render json: { error: "Like not found" }, status: :not_found if like.nil?

        if like.update(click: params[:click], mark_type: params[:mark_type])
            render json: { success: true, click: like.click, mark_type: like.mark_type }, status: :ok
        else
            render json: { success: false, errors: like.errors.full_messages }, status: :unprocessable_entity
        end
    end
end
