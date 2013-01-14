class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
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