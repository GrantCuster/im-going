require 'spec_helper'

describe Event do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :event_title => "value for event title" }
  end
  
  it "should create a new instance given valid attributes" do
    @user.events.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @event = @user.events.create(@attr)
    end
        
    it "should have the right associated user" do
      @event.user_id.should == @user.id
      @event.user.should == @user
    end
    
  end
  
end
