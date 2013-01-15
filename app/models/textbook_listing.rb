class TextbookListing < ActiveRecord::Base
  UID_REGEX = /^\d{1,}$/
  YEAR_REGEX = /^\d{4}$/
  ISBN_REGEX = /^\d{10}\d{3}?$/
  PRICE_REGEX = /^\d+??(?:\.\d{0,2})?$/
  attr_accessible :author, :condition, :description_of_condition, :isbn, :price, :publication_year, :publisher, :title, :uid, :thumbnail

  def self.get_textbook_listings(field, value)
    find(:all, conditions: [field + ' == "' + value + '"'])
  end

  validates :author, presence: true, length: { maximum: 50 }
  validates :condition, presence: true
  validates :isbn, presence: true, format: { with: ISBN_REGEX, message: "should be either 10 or 13 digits." }
  validates :price, format: { with: PRICE_REGEX }, numericality: {greater_than: 0}
  validates :publication_year, presence: true, format: { with: YEAR_REGEX }
  validates :publisher, presence: true, length: { maximum: 50 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :uid, presence: true, format: { with: UID_REGEX }
  validates :description_of_condition, length: { maximum: 180 }
end
