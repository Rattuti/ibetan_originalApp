class RenameColumnsInFavorites < ActiveRecord::Migration[6.0]
  def change
    # user_idをuserに、article_idをarticleに変更
    rename_column :favorites, :user_id, :user
    rename_column :favorites, :article_id, :article

    # click列をboolean型で追加
    add_column :favorites, :click, :boolean, default: false
  end
end
