window.ApplicationRouter = Backbone.Router.extend
  routes:
    "" : "index"
    "/" : "index"
    "/user/edit" : "editUser"
    "/feed" : "friendFeed"
    "feed" : "friendFeed"
    
    "friends/facebook" : "facebookFriends"
    "/friends/facebook" : "facebookFriends"   

    "/users/:user_id" : "userLoad"
    "users/:user_id" : "userLoad"

    "listing/:listing_id/edit" : "listingEdit"

  index: ->
    @populate_listings()
    @populate_side_listings()
    @sideContent(active: "nycx")
  
  friendFeed: ->
    @sideContent(active: "friends")
    @friends_listings = new Listings
    @friends_listings.fetch
      url: "/feed.json"
      success: => 
        view = new ListingsView collection: @friends_listings
        ($ '#main_inner').html view.render().el
        ($ '.month_container').removeClass 'retract'
  
  sideContent: (options) ->
    if oApp.currentUser
      if options.active == (oApp.currentUser.username).replace ' ', ''
        view = new SortOptionsView(active: "you")
      else
        view = new SortOptionsView(options)
    else
      view = new SortOptionsView(active: "nyc")
    ($ ".sort_container").html view.render().el
    header = new ListingsHeader(options)
    ($ '.listing_top').html header.render().el
    unless oApp.currentUser
      sign_view = new SignOptionsView
      ($ ".sort_container").after sign_view.render().el
  
  populate_listings: ->
    listings = new Listings
    listings.reset(preloaded_data)
    listings_view = new ListingsView collection: listings
    ($ '#main_inner').html listings_view.render().el
    ($ '.month').removeClass 'retract'
    button_view = new CreateButton collection: listings
    if oApp.currentUser
      if ($ '.create_container').length == 0
        ($ '.side_content').after button_view.render().el
      else
        ($ '.create_container').replaceWith button_view.render().el
    
  
  populate_side_listings: ->
    side_listings = new SideListings
    side_listings.reset(preloaded_data)
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el

  editUser: ->
    user = new User(oApp.currentUser)
    ($ '#main_column').addClass('inactive')
    view = new UserEditView model: user
    ($ '#panel_container').html view.render().el
  
  userLoad: (user_id) ->
    me = @
    @user = new User
    @user.fetch
      url: "/user/#{user_id}/show.json"
      success: (model, respnse) => 
        view = new UserView model: model
        ($ '.side_content').html view.render().el
        username = (model.getName()).replace ' ', ''
        @sideContent(active: username)
    @user_listings = new Listings
    @user_listings.fetch
      url: "/user/#{user_id}/listing.json"
      success: => 
        view = new ListingsView collection: @user_listings
        ($ '#main_inner').html view.render().el
        ($ '.month_container').removeClass 'retract'

  listingEdit: (listing_id) ->
    ($ '#main_column').addClass('inactive')
    @listing = new Listing
    @listing.fetch
      url: "/listing/#{listing_id}.json"
      success: (model, response) => 
        view = new ListingEdit model: model
        ($ '#panel_container').html view.render().el

  facebookFriends: () ->
    fb_friends = new FbUsers
    fb_friends.reset(preloaded_data)
    view = new FriendsView collection: fb_friends
    ($ '#main_inner').html view.render().el
      