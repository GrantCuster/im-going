class RegistrationsController < Devise::RegistrationsController
  
  def create
    data = session["omniauth"]
    logger.debug data
    logger.debug 'run this one'
    @user = User.check_twitter_or_create(params)
  end

end