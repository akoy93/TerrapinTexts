class TextbookListingsController < ApplicationController
  def new
  end

  def destroy
  end

  def update
  end

  def create
    params[:textbook_listing][:isbn] = params[:isbn]
    @textbook_listing = TextbookListing.new(params[:textbook_listing])
    puts @textbook_listing.inspect
    if @textbook_listing.save
      redirect_to @textbook_listing
    else
      render 'pages/sell'
    end
  end

  def show
    @textbook_listing = TextbookListing.find(params[:id])
  end
end
