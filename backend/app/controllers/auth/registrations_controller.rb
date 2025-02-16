class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :authenticate_user!, except: [:create]
    before_action :admin_only, only: [:update, :destroy]

    def create
        user = User.new(user_params)
        if user.save
            render json: { user: user }, status: :created
        else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def sign_up_params
    # `registration` キーを削除して直接必要なパラメータを許可
    params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
    params.permit(:name, :email, :password, :password_confirmation, :role)
    end

    def admin_only
    unless current_user&.admin?
        render json: { error: "権限がありません" }, status: :forbidden
    end
    end
end
