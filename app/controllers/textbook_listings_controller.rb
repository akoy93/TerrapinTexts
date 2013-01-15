class TextbookListingsController < ApplicationController
  def new
  end

  def destroy
    TextbookListing.find(params[:id]).destroy
    flash[:success] = "Textbook listing deleted."
    redirect_to sell_path
  end

  def update
  end

  def create
    params[:textbook_listing][:isbn] = params[:isbn]
    params[:textbook_listing][:thumbnail] = 
    @textbook_listing = TextbookListing.new(params[:textbook_listing])
    if @textbook_listing.save
      redirect_to sell_path
    else
      redirect_to sell_path errors: @textbook_listing.errors.full_messages
    end
  end

  def self.get_textbook_listings(field, value)
    TextbookListing.get_textbook_listings(field, value)
  end

  def show
    @textbook_listing = TextbookListing.find(params[:id])
  end
end
