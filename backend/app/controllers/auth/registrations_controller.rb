class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    # ユーザー登録・更新・削除
    skip_before_action :verify_authenticity_token, only: [:create]
    # before_action :authenticate_user!, except: [:create]
    # before_action :admin_only, only: [:update, :destroy]

    def create
        Rails.logger.debug("受け取ったパラメータ: #{params.inspect}")

        user = User.new(sign_up_params)
        if user.save
            # DeviseTokenAuthのレスポンスを送信
            render json: { 
                status: 'success', 
                data: user.as_json(only: [:id, :email, :name]), 
                token: user.create_new_auth_token 
            }, status: :created
        else
            Rails.logger.error("User creation failed: #{user.errors.full_messages.join(', ')}")
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity

            flash[:error] = "このメールアドレスはすでに登録されています。"
            render :new

        end
    end

    private

    def sign_up_params
        params.require(:registration).permit(
            :name, 
            :email, 
            :password, 
            :password_confirmation
        )
    end

    def account_update_params
        params.require(:registration).permit(
            :name, 
            :email, 
            :password, 
            :password_confirmation, 
            :role
        )
    end

    def admin_only
        unless current_user&.admin?
            render json: { error: "権限がありません" }, status: :forbidden
        end
    end
end
