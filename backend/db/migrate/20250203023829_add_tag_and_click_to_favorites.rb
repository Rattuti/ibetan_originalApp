class AddTagAndClickToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_column :favorites, :tag, :string
    add_column :favorites, :click, :boolean, default: false
  end
end
