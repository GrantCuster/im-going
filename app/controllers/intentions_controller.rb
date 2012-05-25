class IntentionsController < ApplicationController

  def new
    @intention = Intention.new
  end
  
  def index
  end

  def create
    @intention = current_user.intentions.build(params)
    @intention.save
    render :json => @intention
  end

end