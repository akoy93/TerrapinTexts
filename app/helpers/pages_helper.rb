module PagesHelper
  def validate_isbn(isbn)
    isbn && isbn =~ /^\d{13}$/
  end

  def get_your_textbooks
    TextbookListing.search(uid_eq: current_user.uid).result
  end
end
