class UsersController < ApplicationController

  def show
    @user = User.find(params["user_id"])
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @user }
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
    logger.debug 'user update'
    options = params[:user]
    @user = User.find(current_user.id)
    @user.update_attributes(options)
    respond_to do |format|
      format.json { render :json => @user }
    end
  end
  
end