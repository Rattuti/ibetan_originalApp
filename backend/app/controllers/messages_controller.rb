class MessagesController < ApplicationController
    #skip_before_action :verify_authenticity_token, only: [:create] # 必要なアクションに対してのみ無効化
    #before_action :authenticate_user!, only: ["index"]

    def index
        # ヘッダーのログ出力
        Rails.logger.debug("受信したヘッダー: #{request.headers.inspect}")

        messages = Message.includes(:user, likes: :user).order(created_at: :asc) 
        messages_array = messages.map do |message|
            {
                id: message.id,
                user_id: message.user.id,
                name: message.user.name,
                content: message.content,
                email: message.user.email,
                nickname: message.user.try(:nickname), # nil 対策
                avatar: avatar_url(message.user),
                created_at: message.created_at,
                likes: message.likes.map { |like|
                    {
                        id: like.id,
                        email: like.user.email,
                        uid: like.user.email,
                        click: like.click, # いいねの状態を含める
                        mark_type: like.mark_type # いいねの種類も返
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

    def toggle_like
        # messageの検索
        message = Message.find_by(id: params[:message_id])
        return render json: { success: false, error: "Message not found" }, status: :not_found if message.nil?
    
        # uidの取得
        uid = params[:uid]
        return render json: { success: false, error: "User not found" }, status: :unauthorized if uid.nil?
    
        # Likeの検索または初期化
        like = Like.find_or_initialize_by(message_id: message.id, uid: uid)
    
        # 既存のLikeがあれば状態を切り替え、なければ新規作成
        if like.new_record?
            like.assign_attributes(click: 1, mark_type: params[:mark_type], uid: uid) # 初回はいいねを1にする
        else
            like.click = like.click == 1 ? 0 : 1 # クリックの切り替え
            like.mark_type = params[:mark_type] if params[:mark_type].present? # mark_type が空なら更新しない
        end
    
        if like.save
            ActionCable.server.broadcast "message_#{message.id}", {
                message_id: message.id,
                liked: like.click == 1,
                mark_type: like.mark_type
            }
            render json: { 
                message_id: message.id, 
                click: like.click, 
                mark_type: like.mark_type, 
                uid: like.uid,
                likes: message.likes.select(:id, :uid, :click, :mark_type) # フロントで更新しやすくするため
            }
        else
            render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def avatar_url(user)
        if user.avatar.present?
            "#{request.base_url}#{user.avatar}" # 例: public/uploads に保存されている場合
        else
            "#{request.base_url}/uploads/default_avatar.png" # デフォルト画像
        end
    end
end
