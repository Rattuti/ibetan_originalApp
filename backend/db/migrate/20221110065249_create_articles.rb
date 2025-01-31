class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :feed_id
      t.string :title
      t.string :content
      t.datetime :published
      t.string :url
      t.string :author

      t.timestamps
    end
  end
end
