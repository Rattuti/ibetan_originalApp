class DropFavoritesTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :favorites
  end

  def down
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.integer :bookmark_id
      t.timestamps
    end
  end
end