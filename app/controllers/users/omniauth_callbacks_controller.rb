class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    data = request.env["omniauth.auth"].except('extra')
    
    if current_user
      @user = current_user.update_attributes(:fb_token => data.credentials.token, :fb_id => data.uid)
      redirect_to "/nyc"
    else
      @user = User.find_for_facebook_oauth(data)
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.facebook_data"] = data
        redirect_to "/nyc"
      end
    end
  end
  
  def twitter
    data = request.env["omniauth.auth"].except('extra')
    if current_user
      @user = current_user.update_attributes(:tw_token => data.credentials.token, :tw_secret => data.credentials.secret, :tw_id => data.uid)
      redirect_to "/nyc"
    elsif user = User.find_by_tw_id(data.uid)
      @user = user
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      info = data.info
      bigger_image = (info.image).gsub('_normal','')
      logger.debug "bigger_image"
      logger.debug bigger_image
      info.image = bigger_image
      session[:omniauth] = data
      redirect_to "/users/new"
    end

  end
end