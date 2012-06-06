class UsersController < ApplicationController

  def user
    @user = User.find(params["user_id"])
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { 
        options = { :current_user => current_user }
        render :json => @user.as_json(options)
      }
    end
  end
  
  def index
    @users = User.all
  end
  
  def edit
    @user = User.find(current_user.id)
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @user }
    end
  end

  def update
    options = params[:user]
    @user = User.find(current_user.id)
    @user.update_attributes(options)
    respond_to do |format|
      format.json { render :json => @user }
    end
  end
  
  def facebook_friends
    @graph = User.client(current_user.fb_token)
    @data = @graph.get_object('me/friends')
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @data }
    end    
  end
  
  def follow
    if request.method == "POST"
      follower_id = params[:follower_id]
      followed_id = params[:followed_id]
      relationship = Relationship.create!(followed_id: followed_id, follower_id: follower_id)
      respond_to do |format|
        format.json { render :json => relationship }
      end
    end
    if request.method == "DELETE"
      relationship = current_user.relationships.find_by_followed_id(params[:user_id])
      current_user.unfollow!(params[:user_id])
      respond_to do |format|
        format.json { render :json => relationship }
      end
    end
  end
end