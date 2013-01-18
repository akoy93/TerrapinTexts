class TextbookListingsController < ApplicationController
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
    params[:textbook_listing][:isbn] = params[:isbn]
    @textbook_listing = TextbookListing.new(params[:textbook_listing])
    if @textbook_listing.save
      redirect_to sell_path
    else
      redirect_to sell_path errors: @textbook_listing.errors.full_messages
    end
  end

  def show
  end
end
