class ListingsController < ApplicationController
  
  def feed
    listings = Listing.all
    @data = listings
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => @listing }
    end
  end
  
  def page
  end
  
  def index
  end

  def new
    @listing = Listing.new
  end
  
  def create
    @listing = Listing.create! params
    render :json => @listing
  end
  
end
