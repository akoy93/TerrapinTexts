class TextbookListingsController < ApplicationController
  MAX_LISTINGS = 10  

  def self.max_listings
    MAX_LISTINGS
  end

  def new
  end

  def destroy
    to_delete = TextbookListing.find(params[:id])
    if to_delete[:uid] == current_user.uid # check that user owns listing
      to_delete.destroy
      flash[:success] = "Textbook listing deleted!"
    else
      flash[:error] = "You do not have permission to delete that listing!"
    end
    redirect_to sell_path
  end

  def update
    
  end

  def create
    if current_user.num_listings < MAX_LISTINGS
      exit unless current_user # security check
      params[:textbook_listing][:isbn] = params[:isbn]
      params[:textbook_listing][:name] = current_user.name
      params[:textbook_listing][:uid] = current_user.uid

      @textbook_listing = TextbookListing.new(params[:textbook_listing])
      if @textbook_listing.save
        redirect_to sell_path
      else
        redirect_to sell_path errors: @textbook_listing.errors.full_messages
      end
    else
      redirect_to sell_path errors: ["You have reached the maximum of #{MAX_LISTINGS} textbook listings."]
    end
  end

  def show
  end
end
