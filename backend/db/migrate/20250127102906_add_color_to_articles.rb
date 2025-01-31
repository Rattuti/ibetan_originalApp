class AddColorToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :color, :string
  end
end
