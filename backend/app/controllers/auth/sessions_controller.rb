class Auth::SessionsController < DeviseTokenAuth::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]
    # ログイン・ログアウト処理

    def create
        Rails.logger.info "ログイン処理開始: #{params.inspect}"
    
        user = User.find_by(email: params[:email])

        if user.nil?
            Rails.logger.info "ログイン失敗: ユーザーが見つかりません"
            return render json: { error: "ユーザーが見つかりません" }, status: :unauthorized
        end
    
        if !user.valid_password?(params[:password])
            Rails.logger.info "ログイン失敗: パスワードが一致しません"
            return render json: { error: "パスワードが間違っています" }, status: :unauthorized
        end
    
        if user.respond_to?(:confirmed?) && !user.confirmed?
            Rails.logger.info "ログイン失敗: メール未確認ユーザー"
            return render json: { error: "メールアドレスが確認されていません" }, status: :unauthorized
        end
    
        Rails.logger.info "ログイン成功: ユーザーID=#{user.id}"
    

        # ユーザーが見つからない、またはパスワードが違う場合
        unless user && user.valid_password?(params[:password])
            return render json: { errors: ['Invalid login credentials'] }, status: :unauthorized
        end

        super
    end

    def me
        render json: current_user
    end

    def destroy
        # トークンの認証情報が無効な場合は401を返す
        if user_signed_in?
            sign_out current_user
            head :no_content # 200 OK として空のレスポンス
        else
            render json: { error: 'ログインしていません' }, status: :unauthorized
        end
    end

    def current_user_info
        render json: current_user.slice(
            :id, 
            :name, 
            :email, 
            :role
        )
    end

    private

    def session_params
        params.require(:session).permit(:email, :password)
    end
end
