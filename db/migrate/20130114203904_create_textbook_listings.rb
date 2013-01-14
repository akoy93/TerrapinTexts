class CreateTextbookListings < ActiveRecord::Migration
  def change
    create_table :textbook_listings do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.string :publisher
      t.string :publication_year
      t.float :price
      t.string :description_of_condition
      t.string :condition
      t.string :uid

      t.timestamps
    end
  end
end
