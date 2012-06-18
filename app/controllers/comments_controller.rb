class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(params)
    @comment.save
    
    listing_id = params[:listing_id]
    @listing = Listing.find(listing_id)
    notify_list = Listing.notify_list(@listing)
    notify_list.each do |user|
      if user.id != current_user.id
        UserMailer.comment_notification(user, current_user, @listing).deliver
      end
    end
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @comment }
    end
  end  

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @comment }
    end
  end
  
end