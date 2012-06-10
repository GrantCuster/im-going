class RegistrationsController < Devise::RegistrationsController
  
  def create
    data = {}
    data["params"] = params
    data["session"] = session["omniauth"]
    @user = User.check_twitter_or_create(data)
    if @user.persisted?
      sign_in_and_redirect @user
    end
    session[:omniauth] = nil unless @user.new_record?   
  end

end