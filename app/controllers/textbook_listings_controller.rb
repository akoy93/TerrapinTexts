class TextbookListingsController < ApplicationController
  def new
  end

  def destroy
  end

  def update
  end

  def show
    @textbook_listing = TextbookListing.find(params[:id])
  end
end
