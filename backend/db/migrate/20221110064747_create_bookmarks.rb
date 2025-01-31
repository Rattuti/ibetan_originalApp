class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.references :user
      t.references :message

      t.timestamps
    end
  end
end
