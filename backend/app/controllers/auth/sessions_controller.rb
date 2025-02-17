class Auth::SessionsController < DeviseTokenAuth::SessionsController
    # ログイン・ログアウト処理

    def create
        params.permit(:email, :password)
    end

    def current_user_info
        render json: current_user.slice(
            :id, 
            :name, 
            :email, 
            :role
        )
    end
end
