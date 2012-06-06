class UsersController < ApplicationController

  def show
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
    if request.method == "PUT"
      follower_id = params[:follower_id]
      followed_id = params[:followed_id]
      Relationship.create!(followed_id: followed_id, follower_id: follower_id)
      respond_to do |format|
        format.json { render :json => params }
      end
    end
    if request.method == "DELETE"
      current_user.unfollow!(params[:user_id])
      respond_to do |format|
        format.json { render :json => current_user }
      end
    end
  end
end