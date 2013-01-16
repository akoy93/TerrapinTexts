module PagesHelper
  def validate_isbn(isbn)
    isbn && isbn =~ /^\d{13}$/
  end

  def get_browse_data
    TextbookListing.find(:all) || []
  end
end
