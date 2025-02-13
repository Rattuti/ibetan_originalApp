class AddRoleAndAvatarToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :string, default: 'user', null: false
    add_column :users, :avatar, :string
  end
end
