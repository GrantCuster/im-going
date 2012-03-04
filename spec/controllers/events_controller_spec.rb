require 'spec_helper'

describe EventsController do

  describe "GET 'feed'" do
    it "returns http success" do
      get 'feed'
      response.should be_success
    end
  end

  describe "GET 'page'" do
    it "returns http success" do
      get 'page'
      response.should be_success
    end
  end

end
