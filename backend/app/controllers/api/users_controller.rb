class Api::UsersController < ApplicationController
    before_action :authenticate_user!  # Devise Token Auth の認証
    before_action :require_admin, only: [:index, :update, :destroy]

    # 現在ログインしているユーザーの情報を取得
    def me
        render json: current_user.slice(:id, :name, :email, :role)
    end

    # 管理者が全ユーザーを一覧取得
    def index
        users = User.select(:id, :name, :email, :role, :created_at, :updated_at)
        render json: users
    end

    # 管理者がユーザーを更新
    def update
        user = User.find_by(id: params[:id])
        return render json: { error: "User not found" }, status: :not_found unless user

        if user.update(user_params)
            render json: user  # ユーザー情報を返す
        else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # 管理者がユーザーを削除
    def destroy
        user = User.find_by(id: params[:id])
        return render json: { error: "User not found" }, status: :not_found unless user

        if user.destroy!
            render json: { message: "User deleted successfully" }
        else
            render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
    rescue ActiveRecord::RecordNotDestroyed
        render json: { error: "Failed to delete user due to dependencies" }, status: :unprocessable_entity
    end

    private

    def user_params
        params.permit(:name, :email, :role)
    end

    def require_admin
        unless current_user&.role == "admin"
            render json: { error: "Forbidden" }, status: :forbidden
        end
    end
end
