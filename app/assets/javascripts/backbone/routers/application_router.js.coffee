window.ApplicationRouter = Backbone.Router.extend
  routes:
    "" : "index"

  index: ->
    view = new SortOptionsView
    ($ ".sort_container").html view.render().el
    sign_view = new SignOptionsView
    ($ ".side_container").html sign_view.render().el
    @populate_listings()
    @populate_side_listings()
  
  populate_listings: ->
    listings = new Listings
    listings.reset(preloaded_data)
    view = new ListingsView collection: listings
    ($ '#main_inner').html view.render().el
    ($ '.month').removeClass 'retract'
  
  populate_side_listings: ->
    side_listings = new SideListings
    side_listings.reset(preloaded_data)
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el