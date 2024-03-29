class ListingsController < ApplicationController
  
  def friends_feed
    @data = Listing.from_users_followed_by(current_user).find(:all, :conditions => ["date_and_time > ?", Time.now])
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end
  
  def nyc_feed
    # listings = Listing.find(:all)
    listings = Listing.find(:all, :conditions => ["date_and_time > ?", Time.now])
    @data = listings
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end

  def show
    @data = Listing.find(params[:id])
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end
  end
  
  def update
    options = params[:listing]
    @listing = Listing.find(options[:id])
    @listing.update_attributes(options)
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @listing }
    end
  end
  
  def user
    @user = User.find_by_username(params["username"])
    
    user_id = @user.id
    @data = Listing.where(:user_id => user_id).find(:all, :conditions => ["date_and_time > ?", Time.now])
    intentions = Intention.where(:user_id => user_id)
    intentions.each do |intention|
      listFromIntent = Listing.find(intention.listing_id)
      if listFromIntent.date_and_time > Time.now
        @data.push(listFromIntent)
      end
    end
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end   
  end
  
  def edit
    @listing = Listing.find(params[:listing_id])
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @listing }
    end
  end
  
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
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
    render :layout => "bookmarklet"
  end
  
  def share
    client = params[:client]
    message = params[:message]
    if client == "twitter"
      @twitter = User.init_twitter(current_user.tw_token, current_user.tw_secret)
      @twitter.update(message)
    end
    render :json => params
  end
  
  def create
    @listing = current_user.listings.build(params[:listing])
    @listing.save
    render :json => @listing
    
    if params[:twitter_share] == true
      message = Listing.share_message(@listing)
      @twitter = User.init_twitter(current_user.tw_token, current_user.tw_secret)
      @twitter.update(message)
      User.toggle_share_default(current_user, true, "twitter")
    else
      User.toggle_share_default(current_user, false, "twitter")
    end
  end
  
end