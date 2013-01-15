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
    if @textbook_listing.save
      redirect_to @textbook_listing
    else
      redirect_to sell_path errors: @textbook_listing.errors.full_messages
    end
  end

  def show
    @textbook_listing = TextbookListing.find(params[:id])
  end
end
