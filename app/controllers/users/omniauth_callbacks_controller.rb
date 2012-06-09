class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    data = request.env["omniauth.auth"].except('extra')
    
    @user = User.find_for_facebook_oauth(data)
    
    if @user.persisted?
      sign_in_and_redirect @user
    else
      session["devise.facebook_data"] = data
    end
  end
  
  def twitter
    data = request.env["omniauth.auth"].except('extra')

    if user = User.find_by_tw_id(data.uid)
      @user = user
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session[:omniauth] = data
      redirect_to "/users/new"
    end

  end
end