class Api::UsersController < ApplicationController
    before_action :set_user, only: [:update]

    def update
    if params[:avatar].present?
        uploaded_file = params[:avatar]
        filename = "#{SecureRandom.hex}_#{uploaded_file.original_filename}"
        filepath = Rails.root.join("public/uploads", filename)

        # 画像をサーバーに保存
        File.open(filepath, "wb") do |file|
            file.write(uploaded_file.read)
        end

        # DB に画像のURLを保存（`/uploads/filename.png`）
        @user.update(avatar: "/uploads/#{filename}")
    end

    if params[:nickname].present?
        @user.update(nickname: params[:nickname])
    end

        render json: @user
    end

    private

    def set_user
        @user = User.find_by(id: params[:id])
    end
end
