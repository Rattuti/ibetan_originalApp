class FavoriteChannel < ApplicationCable::Channel
  def subscribed
    # お気に入り機能の特定の「記事」または「タグ」に関連付けたストリームに接続
    stream_from "favorite_#{params[:article_id]}"
  end

  def unsubscribed
    # クライアントが切断したときの処理（オプション）
  end

  def receive(data)
    # 受け取ったデータに基づいて何か処理をすることができる
    # 例: お気に入りの更新状態をデータベースに保存
    article = Article.find(params[:article_id])
    # 必要に応じてデータを更新
    article.update(favorites: data['favorites'])
    
    # 更新された情報を他のクライアントにブロードキャスト
    ActionCable.server.broadcast("favorite_#{params[:article_id]}", { favorites: data['favorites'], active: data['favorites'] == 1 })
  end
end
