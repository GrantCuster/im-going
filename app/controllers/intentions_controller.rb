class IntentionsController < ApplicationController

  def new
    @intention = Intention.new
  end
  
  def index
  end

  def update
    @intention = Intention.find(params[:id])
    @intention.update_attributes(params)
    render :json => @intention
  end

  def destroy
    @intention = Intention.find(params[:id])
    @intention.destroy
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @intention }
    end
  end

  def create
    @intention = current_user.intentions.build(params)
    @intention.save
    
    listing_id = params[:listing_id]
    @listing = Listing.find(listing_id)
    notify_list = Listing.notify_list(@listing)
    notify_list.each do |user|
      if user.id != current_user.id
        UserMailer.intention_notification(user, @listing, @intention).deliver
      end
    end
    
    render :json => @intention
  end

end