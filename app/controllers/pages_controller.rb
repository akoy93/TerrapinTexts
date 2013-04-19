class PagesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'set'

  GOOGLE_BOOKS_API = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
  GRAPH_API = ["https://graph.facebook.com/", "?fields=friends&access_token="]

  def home
  end
  
  def about
  end

  def guidelines
  end

  def buy
    @friends = current_user.friends if params[:friends]
    params[:q].each { |k,v| params[:q][k].strip! } if params[:q]
    if params[:q] && params[:q][params[:q].keys.first] =~ /^\d{1,}$/ 
      generate_book_preview(params[:q][params[:q].keys.first])
    end
    generate_search_results(params[:friends], params[:available])
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

  def generate_search_results(friends_filter, available_filter)
    @search = TextbookListing.search(params[:q])
    # filters
    if friends_filter == "true" && available_filter == "true"
      @listings = Kaminari.paginate_array(@search.result.order('created_at DESC').
        select { |l| l if @friends.include? l.uid && l.date_available <= Date.today }).page(params[:page]).per(10)
    elsif friends_filter == "true" && available_filter != "true"
      @listings = Kaminari.paginate_array(@search.result.order('created_at DESC').
        select { |l| l if @friends.include? l.uid }).page(params[:page]).per(10)
    elsif friends_filter != "true" && available_filter == "true"
      @listings = Kaminari.paginate_array(@search.result.order('created_at DESC').
        select { |l| l if l.date_available <= Date.today }).page(params[:page]).per(10)
    else
      # show all
      @listings = @search.result.order('created_at DESC').page(params[:page]).per(10)
    end
  end

  def get_book_fields_ajax
    @textbook_listing = TextbookListing.new
    isbn = params[:isbn].strip
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
