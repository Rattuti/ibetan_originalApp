class AddTimestampsToEvents < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :events, default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end
end