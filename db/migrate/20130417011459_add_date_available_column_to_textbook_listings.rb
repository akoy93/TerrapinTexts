class AddDateAvailableColumnToTextbookListings < ActiveRecord::Migration
  def change
    add_column :textbook_listings, :date_available, :date
  end
end
