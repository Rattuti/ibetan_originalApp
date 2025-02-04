class RemoveMarkerTypeFromFavorites < ActiveRecord::Migration[6.0]
  def change
    remove_column :favorites, :marker_type, :string
  end
end
