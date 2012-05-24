class IntentionssController < ApplicationController

  def create
    @intention = current_user.intentions.build(params[:listing])
    @intention.save
    render :json => @intention
  end

end