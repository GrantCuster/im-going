class IntentionsController < ApplicationController

  def new
    @intention = Intention.new
  end
  
  def index
  end

  def update
    @intention = Intention.find(params[:id])
    @intention.update_attributes(params)
    render :json => @intention
  end

  def destroy
    @intention = Intention.find(params[:id])
    @intention.destroy
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @intention }
    end
  end

  def create
    @intention = current_user.intentions.build(params)
    @intention.save

    render :json => @intention
  end

end