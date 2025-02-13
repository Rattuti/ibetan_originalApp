class ModifyEventsAddAttributes < ActiveRecord::Migration[6.0]
  def change
    change_table :events do |t|
      t.remove :location  # location列を削除
      t.boolean :judge, default: false  # judge列を追加
      t.references :user, null: false, foreign_key: true  # user_id列を追加
      t.string :color  # color列を追加
    end
  end
end
