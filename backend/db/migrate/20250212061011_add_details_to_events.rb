class AddDetailsToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :user_id, :integer
    add_column :events, :content, :text
  end
end
