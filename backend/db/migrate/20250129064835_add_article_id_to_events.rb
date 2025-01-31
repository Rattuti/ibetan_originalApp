class AddArticleIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :article_id, :integer
  end
end
