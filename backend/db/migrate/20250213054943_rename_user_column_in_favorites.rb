class RenameUserColumnInFavorites < ActiveRecord::Migration[6.0]
  def change
    rename_column :favorites, :user, :user_id
  end
end
