class AddThumbnailColumnToTextbookListings < ActiveRecord::Migration
  def change
    add_column :textbook_listings, :thumbnail, :string
  end
end
