class AddJudgeToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :judge, :boolean, default: false, null: false
  end
end
