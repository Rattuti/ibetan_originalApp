class Auth::SessionsController < ApplicationController
    # ログイン・ログアウト処理
    before_action :authenticate_user!

    def current_user_info
    render json: current_user.slice(:id, :name, :email, :role)
    end
end
