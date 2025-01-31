class AddCostToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :cost, :string
  end
end
