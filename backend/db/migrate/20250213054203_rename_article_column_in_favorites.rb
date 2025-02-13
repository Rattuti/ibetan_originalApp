class RenameArticleColumnInFavorites < ActiveRecord::Migration[6.0]
  def change
    rename_column :favorites, :article, :article_id
  end
end
