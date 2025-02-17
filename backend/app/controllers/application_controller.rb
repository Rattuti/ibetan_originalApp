class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        before_action :skip_forgery_protection

        private

        def skip_forgery_protection
                request.session_options[:skip] = true
        end
end
