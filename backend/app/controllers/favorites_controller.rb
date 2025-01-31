class FavoritesController < ApplicationController
    before_action :authenticate_user!, only: ['create']

    def create
        favorite = Favorite.new(message_id: params[:id], user_id: current_user.id)

        if favorite.save
            render json: { id: favorite.id, email: current_user.uid, message: '成功しました' }, status: 200
        else
            render json: { message: '保存出来ませんでした', errors: favorite.errors.messages }, status: 400
        end
    end

    def destroy
        favorite = Favorite.find(params[:id])
    
        if favorite.destroy
            render json: { id: favorite.id, email: favorite.user.uid, message: '削除に成功しました' }, status: 200
        else
            render json: { message: '削除できませんでした', errors: favorite.errors.messages }, status: 400
        end
    end
end
