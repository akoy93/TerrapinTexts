module PagesHelper
  def validate_isbn(isbn)
    isbn.length == 13 && isbn =~ /\d{13}/
  end
end
