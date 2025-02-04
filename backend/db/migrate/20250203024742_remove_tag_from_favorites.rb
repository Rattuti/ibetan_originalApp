class RemoveTagFromFavorites < ActiveRecord::Migration[6.0]
  def change
    remove_column :favorites, :tag, :string  # tag列を削除
  end
end
