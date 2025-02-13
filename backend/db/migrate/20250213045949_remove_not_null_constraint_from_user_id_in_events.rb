class RemoveNotNullConstraintFromUserIdInEvents < ActiveRecord::Migration[6.0]
  def change
    change_column_null :events, :user_id, true
  end
end
