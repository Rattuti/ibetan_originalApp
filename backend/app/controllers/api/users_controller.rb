class Api::UsersController < ApplicationController
    before_action :set_user, only: [:update, :show]

    def index
        users = User.all
        render json: { users: users }
    end

    def update
        if params[:avatar].present?
            uploaded_image = params[:avatar]

            # フォルダ作成（存在しない場合）
            directory = Rails.root.join('public', 'uploads', 'avatars')
            FileUtils.mkdir_p(directory) unless File.directory?(directory)

            # 画像ファイルのパスを決定
            file_name = "#{@user.id}_avatar.jpg"
            file_path = directory.join(file_name)

            # 画像をローカルに保存
            File.open(file_path, 'wb') do |file|
            file.write(uploaded_image.read)
            end

            # DBに保存するURLを設定
            @user.update(avatar: "/uploads/avatars/#{file_name}")
        end

        @user.update(nickname: params[:nickname]) if params[:nickname].present?

        render json: {
            message: "プロフィールを更新しました",
            avatar: avatar_url(@user),
            nickname: @user.nickname
        }, status: :ok
    end

    def show
        user = User.find(params[:id])
        render json: {
            id: user.id,
            nickname: user.nickname || user.name || "匿名",
            avatar: user.avatar.presence || "/uploads/avatars/default_avatar.jpg" # デフォルト画像のパス
        }
    end

    private

    def set_user
        @user = current_user # または User.find(params[:id]) に変更
    end

    def avatar_url(user)
        host = Rails.env.production? ? ENV['HOST'] : "http://localhost:3000"
        puts "HOST: #{host}, Avatar: #{user.avatar}" # デバッグ出力
        "#{host}#{user.avatar}"
    end
end
