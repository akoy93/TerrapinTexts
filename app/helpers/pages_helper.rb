module PagesHelper
  def validate_isbn(isbn)
    isbn && isbn =~ /^\d{10}\d{3}?$/
  end
end
