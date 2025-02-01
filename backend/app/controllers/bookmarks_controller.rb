class BookmarksController < ApplicationController
    #before_action :authenticate_user!, only: ['create']

    def create
        bookmark = Bookmark.new(message_id: params[:id], user_id: current_user.id)

        if bookmark.save
            render json: { id: bookmark.id, email: current_user.email, message: '成功しました' }, status: 200
        else
            render json: { message: '保存出来ませんでした', errors: bookmark.errors.messages }, status: 400
        end
    end

    def destroy
        bookmark = Bookmark.find(params[:id])
    
        if bookmark.destroy
            render json: { id: bookmark.id, email: bookmark.user.email, message: '削除に成功しました' }, status: 200
        else
            render json: { message: '削除できませんでした', errors: bookmark.errors.messages }, status: 400
        end
    end

end
