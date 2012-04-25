window.ApplicationRouter = Backbone.Router.extend
  routes:
    "" : "index"

  index: ->
    sign_options = new SignOptionsView
    ($ ".sign_options").html sign_options.render().el
    @populate_listings()
    @populate_side_listings()
  
  populate_listings: ->
    listings = new Listings
    listings.reset(preloaded_data)
    view = new ListingsView collection: listings
    ($ '#main_inner').html view.render().el
    view
  
  populate_side_listings: ->
    side_listings = new SideListings
    side_listings.reset(preloaded_data)
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el