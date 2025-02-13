class RemoveColumnsFromArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :feed_id, :integer
    remove_column :articles, :published, :boolean
    remove_column :articles, :author, :string
  end
end
