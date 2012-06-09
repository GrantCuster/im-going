class UsersController < ApplicationController

  def show
    @user = User.find_by_username(params["username"])
    options = { :current_user => current_user }
    @user = @user.as_json(options)
    
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @user }
    end
  end
  
  def new
    @data = session[:omniauth]
    
    respond_to do |format|
      format.html { render 'listings/feed' }
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
    if current_user
      @user = User.find(current_user.id)
      @user.update_attributes(options)
    else
      if @user = User.find_by_email(options[:email])
        @user.update_attributes(options)
      end
    end
    respond_to do |format|
      format.json { render :json => @user }
    end
  end
  
  def facebook_friends
    @data = []
    options = { :current_user => current_user }
    @graph = User.client(current_user.fb_token)
    @fb_friends = @graph.get_object('me/friends')
    fb_ids = @fb_friends.collect do |friend|
      friend["id"]
    end
    @users = User.where('fb_id IN (?)', fb_ids)
    @users.each do |user|
      user_full = user.as_json(options)
      @data.push user_full
    end
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