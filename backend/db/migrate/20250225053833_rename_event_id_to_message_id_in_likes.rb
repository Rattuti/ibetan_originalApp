class RenameEventIdToMessageIdInLikes < ActiveRecord::Migration[6.0]
  def change
    rename_column :likes, :event_id, :message_id
  end
end
