class AddEmailColumnToTextbookListings < ActiveRecord::Migration
  def change
    add_column :textbook_listings, :email, :string
  end
end
