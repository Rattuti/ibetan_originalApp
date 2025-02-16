class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.bigint :user_id
      t.string :name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
