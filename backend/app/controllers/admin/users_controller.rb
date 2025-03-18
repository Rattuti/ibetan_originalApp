class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    #before_action :require_admin, only: [:index, :update, :destroy]

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
            Rails.logger.info "Current user: #{current_user&.id}, role: #{current_user&.role}"
            render json: User.all
        rescue => e
            Rails.logger.error "Error fetching users: #{e.message}"
            render json: { error: "Internal Server Error" }, status: :internal_server_error
    end

    def show
        user = User.find(params[:id])
        render json: {
            id: user.id,
            nickname: user.nickname || user.name || "匿名",
            avatar: user.avatar.presence || "/uploads/avatars/default_avatar.jpg" # デフォルト画像のパス
        }
    end

    def update
        user = User.find(params[:id])
        if user.update(user_params)
            render json: user
        else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        user = User.find(params[:id])
        if user.destroy
            render json: { message: "User deleted successfully" }
        else
            render json: { error: "Failed to delete user" }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        if current_user.admin?
            params.permit(:name, :email, :role)
        else
            params.permit(:name, :email)
        end
    end

    def require_admin
        render json: { error: "Forbidden" }, status: :forbidden unless current_user&.admin?
    end

    def record_not_found
        render json: { error: "User not found" }, status: :not_found
    end

    def record_invalid
        render json: { error: "Invalid request" }, status: :unprocessable_entity
    end
end
