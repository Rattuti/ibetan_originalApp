class ChangeClickColumnTypeInFavorites < ActiveRecord::Migration[6.0]
  def up
    # 既存の click カラムを削除
    remove_column :favorites, :click, :boolean

    # 新たに click カラムを integer 型で追加
    add_column :favorites, :click, :integer, default: 0, null: false
  end

  def down
    # integer 型の click カラムを削除
    remove_column :favorites, :click, :integer

    # boolean 型で click カラムを再追加
    add_column :favorites, :click, :boolean, default: false, null: false
  end
end
