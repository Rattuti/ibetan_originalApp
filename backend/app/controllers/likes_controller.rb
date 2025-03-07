class LikesController < ApplicationController
    before_action :authenticate_user!  # devise_token_auth を使用
    before_action :set_message, only: [:create]

    def create
        message = Message.find(params[:message_id])
        like = message.likes.find_or_initialize_by(user_id: current_user.id)
    
        like.email = current_user.email
        like.mark_type = params[:mark_type] || "heart"  # mark_type が渡っていない場合にデフォルト値を設定
        like.click = 1  # 初回いいね（デフォルトは1）
    
        if like.save
            render json: { click: like.click, mark_type: like.mark_type }
        else
            render json: { error: "いいねの保存に失敗しました" }, status: :unprocessable_entity
        end
    end
    
    
    def toggle
        like = Like.find_or_initialize_by(user_id: current_user.id, message_id: params[:message_id])
    
        if like.new_record?
        # 初回クリックは 1 にする
        like.click = 1
        else
        # クリックの状態を 0 → 1 → 2 → 0 に変更
        like.click = (like.click + 1) % 3
        end
    
        like.mark_type = params[:mark_type]
        like.uid = current_user.email
    
        if like.save
        render json: { click: like.click, mark_type: like.mark_type, uid: like.uid }
        else
        Rails.logger.debug "🔴 Likeの保存に失敗: #{like.errors.full_messages}"
        render json: { error: like.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    

    def destroy
        @like = Like.find(params[:id])
        @like.destroy
        head :no_content
    end
    
    private

    def like_params
        params.require(:like).permit(:mark_type, :click)
    end
    
    def set_message
        @message = Message.find(params[:message_id])
    end
    
    def set_like
        @like = Like.find(params[:id]) # ここでlike_idを取得
    end
    
    def broadcast_likes_count(message)
        ActionCable.server.broadcast "likes_channel", { message_id: message.id, likes_count: message.likes.count }
    end
end