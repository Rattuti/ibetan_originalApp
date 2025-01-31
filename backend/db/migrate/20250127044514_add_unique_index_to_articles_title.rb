class AddUniqueIndexToArticlesTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :articles, :title, unique: true
  end
end
