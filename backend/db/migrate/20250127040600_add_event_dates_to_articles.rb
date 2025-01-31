class AddEventDatesToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :event_dates, :string
  end
end
