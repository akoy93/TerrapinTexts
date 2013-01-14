class TextbookListing < ActiveRecord::Base
  attr_accessible :author, :condition, :description_of_condition, :isbn, :price, :publication_year, :publisher, :title, :uid
end
