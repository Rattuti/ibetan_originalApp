class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken

        before_action :configure_permitted_parameters, if: :devise_controller?
        before_action :log_auth_headers  # 🔍 ヘッダー情報をログ出力

        private

        def configure_permitted_parameters
                devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        end

        # 🔍 認証情報をデバッグ出力
        def log_auth_headers
        logger.debug "🔍 Authorization: #{request.headers['Authorization']}"
        logger.debug "🔍 client: #{request.headers['client']}"
        logger.debug "🔍 uid: #{request.headers['uid']}"
        Rails.logger.info "🔍 受信したヘッダー: #{request.headers.to_h.slice('access-token', 'client', 'uid')}"
        end
end
