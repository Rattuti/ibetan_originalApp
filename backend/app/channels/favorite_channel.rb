class FavoriteChannel < ApplicationCable::Channel
  def subscribed
    if current_user
      stream_from "favorite_channel_#{params[:article_id]}"
    else
      reject_unauthorized_connection
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    favorite_data = data["favorite"]
    article_id = favorite_data["id"]

    # 記事が存在するか確認
    article = Article.find_by(id: article_id)
    unless article
      # エラーメッセージを送信
      ActionCable.server.broadcast(
        "favorite_channel_#{params[:article_id]}",
        { error: "Article not found" }
      )
      return
    end

    user = current_user
    unless user
      # エラーメッセージを送信
      ActionCable.server.broadcast(
        "favorite_channel_#{params[:article_id]}",
        { error: "User not found" }
      )
      return
    end

    # すでにお気に入りが存在するか確認
    favorite = Favorite.find_by(user_id: user.id, article_id: article.id)
    
    if favorite
      # すでにお気に入りが存在する場合はclickの値を反転
      new_click_value = favorite.click == 1 ? 0 : 1
      favorite.update(click: new_click_value)
      active = new_click_value == 1
    else
      # 新しくお気に入りを作成
      Favorite.create!(user_id: user.id, article_id: article.id, click: 1)
      active = true
    end

    # クリックされたお気に入りの数をカウント (clickが1のものをカウント)
    favorites_count = Favorite.where(article_id: article.id, click: 1).count

    # ブロードキャストで更新情報を送信
    ActionCable.server.broadcast(
      "favorite_channel_#{params[:article_id]}",
      { 
        article_id: article.id,
        user_id: user.id,
        active: active,
        favorites: favorites_count
      }
    )
  end
end
