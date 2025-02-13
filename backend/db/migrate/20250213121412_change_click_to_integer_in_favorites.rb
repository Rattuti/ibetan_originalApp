class ChangeClickToIntegerInFavorites < ActiveRecord::Migration[6.0]
  def change
    # 1. デフォルト値を一時的に削除（boolean → integer 変換時のエラーを防ぐ）
    change_column_default :favorites, :click, nil

    # 2. 一時的に TEXT 型に変換
    execute <<-SQL
      ALTER TABLE favorites 
      ALTER COLUMN click TYPE TEXT 
      USING click::TEXT;
    SQL

    # 3. TEXT から INTEGER に変換（true → 1, false → 0 にする）
    execute <<-SQL
      ALTER TABLE favorites 
      ALTER COLUMN click TYPE INTEGER 
      USING CASE 
        WHEN click = 't' THEN 1 
        WHEN click = 'f' THEN 0 
        ELSE 0 
      END;
    SQL

    # 4. デフォルト値を設定（今後のデータ追加のため）
    change_column_default :favorites, :click, 0

    # 5. NULL 制約を追加（データ整合性のため）
    change_column_null :favorites, :click, false, 0
  end
end
