class RemoveArticleIdFromArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :article_id, :integer
  end
end
