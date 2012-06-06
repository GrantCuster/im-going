window.ApplicationRouter = Backbone.Router.extend
  routes:
    "nyc" : "index"
    "/nyc" : "index"
    ":username" : "profile"
    "/:username" : "profile"
    "friends/feed" : "friends_feed"
    "/friends/feed" : "friends_feed"

  fetch_or_preload_city_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      @data_loaded = true
    else
      listings.fetch
        url: "/nyc"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings)

  fetch_or_preload_friends_feed_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      @data_loaded = true
    else
      listings.fetch
        url: "/friends/feed.json"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings) 
 
  fetch_or_preload_user_and_listings: (username) ->
    if preloaded_data? && !@data_loaded?
      user = new User preloaded_data.user
      @populate_user(user)
      listings = new Listings
      listings.reset(preloaded_data.listings)
      @populate_listings(listings)
      @data_loaded = true
    else
      user = new User
      # This is wrong but I could not get a plain getJSON function to work
      user.fetch
        url: "/#{username}.json"
        success: (bad_model, response) =>
          user = new User response.user
          @populate_user(user)
          listings = new Listings
          listings.reset(response.listings)
          @populate_listings(listings)        

  populate_user: (user) ->
    view = new UserView model: user
    ($ '.side_content').html view.render().el
    
  populate_listings: (listings) ->
    listings_view = new ListingsView collection: listings
    ($ '#main_inner').html listings_view.render().el

  populate_side_listings: (side_listings) ->
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el

  populate_side: (options) ->
    view = new SortOptionsView(options)
    ($ ".sort_container").html view.render().el
    if options.active == "you"
      header = new ListingsHeader(active: oApp.currentUser.username)
    else
      header = new ListingsHeader(options)
    ($ '.listing_top').html header.render().el
    unless oApp.currentUser
      sign_view = new SignOptionsView
      ($ ".sort_container").after sign_view.render().el

  index: ->
    @fetch_or_preload_city_listings()
    @populate_side(active: "nyc")

  profile: (username) ->
    @fetch_or_preload_user_and_listings(username)
    if oApp.currentUser && oApp.currentUser.username == username
      @populate_side(active: "you")
    else
      @populate_side()
   
  friends_feed: ->
    @fetch_or_preload_friends_feed_listings()
    @populate_side(active: "friends")

  # editUser: ->
  #   user = new User(oApp.currentUser)
  #   ($ '#main_column').addClass('inactive')
  #   view = new UserEditView model: user
  #   ($ '#panel_container').html view.render().el
  # 
  # listingEdit: (listing_id) ->
  #   ($ '#main_column').addClass('inactive')
  #   @listing = new Listing
  #   @listing.fetch
  #     url: "/listing/#{listing_id}.json"
  #     success: (model, response) => 
  #       view = new ListingEdit model: model
  #       ($ '#panel_container').html view.render().el
  # 
  # facebookFriends: () ->
  #   fb_friends = new FbUsers
  #   fb_friends.reset(preloaded_data)
  #   view = new FriendsView collection: fb_friends
  #   ($ '#main_inner').html view.render().el
      