class FavoritesController < ApplicationController
  def create
    logger.debug "Received params: #{params.inspect}"
    article = Article.find_by(id: params[:article_id])
    unless article
      render json: { error: "Article not found" }, status: :not_found
      return
    end
  
    user = User.find_by(id: 1)  # 仮のユーザーID
  
    unless user
      render json: { error: "User not found" }, status: :not_found
      return
    end
  
    @favorite = Favorite.find_or_initialize_by(
      user_id: user.id, 
      article_id: params[:article_id]
    )
  
    # 受け取った `click` 値で状態を更新
    click_value = params[:favorite][:click]
    @favorite.click = click_value.to_i
  
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
end
