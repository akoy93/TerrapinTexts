class TextbookListing < ActiveRecord::Base
  UID_REGEX = /^\d{1,}$/
  YEAR_REGEX = /^\d{4}$/
  ISBN_REGEX = /^\d{13}$/
  PRICE_REGEX = /^\d+??(?:\.\d{0,2})?$/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :author, :condition, :description_of_condition, :isbn, :price, 
    :publication_year, :publisher, :title, :uid, :thumbnail, :email, :course, :name, 
    :date_available

  # Normal usage where " aaa   bbb\t " changes to "aaa bbb"
  auto_strip_attributes :description_of_condition, :isbn, :author, 
    :publication_year, :publisher, :title, :comment
  # Squeezes spaces inside the string: "James   Bond  " => "James Bond"
  auto_strip_attributes :author, :description_of_condition, :publisher, :title, :squish => true

  validates :author, presence: true, length: { maximum: 100 }
  validates :condition, presence: true
  validates :isbn, format: { with: ISBN_REGEX, message: "should be 13 digits." }
  validates :price, format: { with: PRICE_REGEX }, numericality: {greater_than: 0}
  validates :publication_year, format: { with: YEAR_REGEX }
  validates :publisher, presence: true, length: { maximum: 50 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :uid, format: { with: UID_REGEX }
  validates :description_of_condition, length: { maximum: 180 }
  validates :email, format: { with: EMAIL_REGEX }, length: { maximum: 100 }
  validates :name, presence: true
  validates :date_available, presence: true
end
