class AddEncryptedPasswordAndUnconfirmedEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :unconfirmed_email, :string
  end
end
