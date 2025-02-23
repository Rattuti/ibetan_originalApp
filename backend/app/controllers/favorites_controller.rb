class FavoritesController < ApplicationController
  def create    
    puts "🔍 Authorization: #{request.headers['Authorization']}"
    puts "🔍 client: #{request.headers['client']}"
    puts "🔍 uid: #{request.headers['uid']}"

    # 🔍 ヘッダーから `uid` を取得
    uid = request.headers["uid"]
    
    # `uid` から `User` を検索
    user = User.find_by(uid: uid)
    logger.debug "Found user: #{user.inspect}"

    unless user
      render json: { error: "User not found" }, status: :unauthorized
      return
    end

    # 記事を検索
    article = Article.find_by(id: params[:article_id])
    unless article
      render json: { error: "Article not found" }, status: :not_found
      return
    end

    # `user.id` を使って `Favorite` を作成・更新
    click_value = params.dig(:favorite, :click) || 0
    @favorite = Favorite.find_or_initialize_by(
      user_id: user.id, 
      article_id: article.id
    )

    @favorite.click = click_value

    if @favorite.save
      favorites_count = Favorite.where(
        article_id: @favorite.article_id, 
        click: 1
      ).count

      # ブロードキャスト
      ActionCable.server.broadcast(
        "favorite_channel_#{article.id}",
        {
          article_id: @favorite.article_id,
          user_id: user.id,
          active: @favorite.click == 1,
          favorites: favorites_count
        }
      )

      render json: {
        message: 'お気に入りが更新されました',
        favorite: {
          article_id: @favorite.article_id,
          click: @favorite.click
        } 
      }, status: :ok
    else
      render json: { error: '更新に失敗しました' }, status: :unprocessable_entity
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:click)
  end

end
