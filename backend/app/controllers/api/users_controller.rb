class Api::UsersController < ApplicationController
    before_action :set_user, only: [:update]

    def update
        if current_user.update(avatar_params)
            render json:{avatar:url_for(current_user.avatar)},status: :ok
        else
            render json:{error: "Failed to update avatar"},status: :unprocessable_entity
        end    
    end

    if params[:nickname].present?
        @user.update(nickname: params[:nickname])
    end

        render json: @user
    end

    def show
        render json:{user:current_user, avatar: url_for(current_user.avatar)}
    end


    private

    def set_user
        @user = User.find_by(id: params[:id])
    end

    def avatar_params
        params.require(:user).permit(:avatar)
    end
end
