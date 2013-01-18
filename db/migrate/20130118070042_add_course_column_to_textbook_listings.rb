class AddCourseColumnToTextbookListings < ActiveRecord::Migration
  def change
    add_column :textbook_listings, :course, :string
  end
end
