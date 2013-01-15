class TextbookListing < ActiveRecord::Base
  PRICE_REGEX = /^\d{1,4}\.\d{1,2}$/
  UID_REGEX = /^\d{1,}$/
  YEAR_REGEX = /^\d{4}$/
  ISBN_REGEX = /^\d{10}\d{3}?$/

  attr_accessible :author, :condition, :description_of_condition, :isbn, :price, :publication_year, :publisher, :title, :uid

  validates :author, presence: true, length: { maximum: 50 }
  validates :condition, presence: true, length: { maximum: 10 }
  validates :isbn, presence: true, format: { with: ISBN_REGEX, message: "should be either 10 or 13 digits." }
  validates :price, presence: true, format: { with: PRICE_REGEX, message: "should be in the format ###.##" }
  validates :publication_year, presence: true, format: { with: YEAR_REGEX, message: "should be in the format ####." }
  validates :publisher, presence: true, length: { maximum: 50 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :uid, presence: true, format: { with: UID_REGEX }
  validates :description_of_condition, length: { maximum: 180 }
end