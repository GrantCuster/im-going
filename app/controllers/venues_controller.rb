class VenuesController < ApplicationController

  def index
    @venues = Venue.all
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @venues }
    end
  end

  def create
    @venue = current_user.venues.build(params[:venue])
    @venue.save
    render :json => @listing
  end

  def new
    @venue = Venue.new
  end

end