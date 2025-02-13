class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :article_id
      t.string :title
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
    end
  end
end
