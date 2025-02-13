class AddArticleIdAndFavoritesToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :article_id, :integer
    add_column :articles, :favorites, :integer, default: 0 # 初期値として0を設定
  end
end
