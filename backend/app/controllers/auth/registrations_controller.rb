class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    # ユーザー登録処理をカスタマイズ
    before_action :authenticate_user!
    before_action :admin_only, only: [:update, :destroy]

    private

    def sign_up_params
        params.permit(
            :name, 
            :email, 
            :password, 
            :password_confirmation, 
            :role
        )
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
