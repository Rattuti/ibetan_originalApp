class ChangeArticleIdNullOnEvents < ActiveRecord::Migration[6.0]
  def change
    change_column_null :events, :article_id, true
  end
end
