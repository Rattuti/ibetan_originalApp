class AddUidToLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :uid, :string
  end
end
