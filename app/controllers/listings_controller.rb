class ListingsController < ApplicationController
  
  def friend_feed
    @data = Listing.from_users_followed_by(current_user)
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end
  
  def city_feed
    listings = Listing.all
    @data = listings
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end

  def show
    @listing = Listing.find(params[:listing_id])
    respond_to do |format|
      format.json { render :json => @listing }
    end
  end
  
  def user
    user_id = params[:user_id]
    @listings = Listing.where(:user_id => user_id)
    intentions = Intention.where(:user_id => user_id)
    intentions.each do |intention|
      listFromIntent = Listing.find(intention.listing_id)
      @listings.push(listFromIntent)
    end
    
    respond_to do |format|
      format.json { render :json => @listings }
    end   
  end
  
  def edit
    @listing = Listing.find(params[:listing_id])
    respond_to do |format|
      format.html { render 'listings/feed' }
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
    @listing = current_user.listings.build(params[:listing])
    @listing.save
    render :json => @listing
  end
  
end