class AddNameColumnToTextbookListings < ActiveRecord::Migration
  def change
    add_column :textbook_listings, :name, :string
  end
end
