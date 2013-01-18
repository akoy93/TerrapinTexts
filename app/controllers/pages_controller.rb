class PagesController < ApplicationController
  require 'open-uri'
  require 'json'

  GOOGLE_BOOKS_API = "https://www.googleapis.com/books/v1/volumes?q=isbn:"

  def home
  end

  def buy
    params[:q].each { |k,v| params[:q][k].strip! } if params[:q]
    if params[:q] && params[:q][params[:q].keys.first] =~ /^\d{1,}$/ 
      generate_book_preview(params[:q][params[:q].keys.first])
    end
    generate_search_results
  end

  def sell
    @textbook_listing = TextbookListing.new
  end

  def generate_book_preview(isbn)
    if validate_isbn(isbn)
      @book_query = book_query(isbn)
      @error = { failure: "Unable to generate book preview because ISBN #{isbn} was not found. Make sure you entered in a correct 13 digit ISBN." } unless @book_query
    else
      @error = { error: "#{isbn} is not a valid input. Make sure your ISBN 13 digits long." }
    end 
  end

  def generate_search_results
    @search = TextbookListing.search(params[:q])
    @listings = @search.result.order('created_at DESC').page(params[:page]).per(5)
  end


  def get_book_fields_ajax
    @textbook_listing = TextbookListing.new
    isbn = params[:isbn].strip!
    if validate_isbn(isbn)
      @book_query = book_query(isbn)
      @error = { failure: "Unable to generate book preview because ISBN #{isbn} was not found. If your ISBN is correct, enter the book information manually." } unless @book_query
    elsif !isbn.empty?
      @error = { error: "#{isbn} is not a valid input. Make sure your ISBN is 13 digits long." }
    end
  end

  def validate_isbn(isbn)
    isbn && isbn =~ /^\d{13}$/
  end

  def book_query(isbn)
    url = GOOGLE_BOOKS_API + isbn
    begin    
      raw_data = open(url).read
      json_data = JSON.parse(raw_data)
      hashed_data = {}
      hashed_data[:authors] = json_data["items"][0]["volumeInfo"]["authors"]
      hashed_data[:title] = json_data["items"][0]["volumeInfo"]["title"]
      hashed_data[:subtitle] = json_data["items"][0]["volumeInfo"]["subtitle"]
      hashed_data[:publisher] = json_data["items"][0]["volumeInfo"]["publisher"]
      hashed_data[:description] = json_data["items"][0]["volumeInfo"]["description"]
      hashed_data[:publication_year] = json_data["items"][0]["volumeInfo"]["publishedDate"][0..3]
      hashed_data[:thumbnail] = json_data["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
      hashed_data
    rescue
      return nil
    end
  end
end
