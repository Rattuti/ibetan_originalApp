class AddMarkTypeToLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :click, :integer
    add_column :likes, :mark_type, :string
  end
end
