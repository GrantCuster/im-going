class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    data = request.env["omniauth.auth"].except('extra')
    
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"].except('extra'), current_user)
    
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except('extra')
    end
  end
end