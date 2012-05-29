window.ApplicationRouter = Backbone.Router.extend
  routes:
    "" : "index"

  index: ->
    view = new SortOptionsView
    ($ ".sort_container").html view.render().el
    unless oApp.currentUser
      sign_view = new SignOptionsView
      ($ ".side_container").html sign_view.render().el
    @populate_listings()
    @populate_side_content()
  
  populate_listings: ->
    listings = new Listings
    listings.reset(preloaded_data)
    listings_view = new ListingsView collection: listings
    ($ '#main_inner').html listings_view.render().el
    ($ '.month').removeClass 'retract'
    button_view = new CreateButton collection: listings
    ($ '.side_content').after button_view.render().el
  
  populate_side_content: ->
    side_listings = new SideListings
    side_listings.reset(preloaded_data)
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el