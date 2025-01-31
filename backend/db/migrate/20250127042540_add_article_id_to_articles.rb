class AddArticleIdToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :article_id, :integer
  end
end
