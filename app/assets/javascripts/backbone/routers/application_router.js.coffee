window.ApplicationRouter = Backbone.Router.extend
  routes:
    "nyc" : "index"
    "/nyc" : "index"
    "friends" : "friends_feed"
    "/friends" : "friends_feed"
    ":username/find_friends" : "find_friends"
    ":username" : "profile"
    "/:username" : "profile"

  fetch_or_preload_city_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      @populate_create_button(listings)     
      @data_loaded = true
    else
      listings.fetch
        url: "/nyc"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings)
          @populate_create_button(listings)

  fetch_or_preload_friends_feed_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      @populate_create_button(listings)
      @data_loaded = true
    else
      listings.fetch
        url: "/friends.json"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings)
          @populate_create_button(listings)
 
  # Has to be a better way to do this
  fetch_user: (username) ->
    user = new User
    user.fetch
      url: "/#{username}/show.json"
      success: (user, response) =>
        @populate_user(user)     

  fetch_or_preload_user_listings: (username) ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      @data_loaded = true
    else
      listings.fetch
        url: "/#{username}"
        success: (listings, response) =>
          @populate_listings(listings)

  fetch_or_preload_find_friends: (username) ->
    if preloaded_data? && !@data_loaded?
      friends = new Users preloaded_data
      friends.reset(preloaded_data)
      @populate_friends(friends)
      @data_loaded = true
    else
      friends = new Users
      friends.fetch
        url: "/#{oApp.currentUser.username}/find_friends.json"
        success: (friends, response) =>
          @populate_friends(friends)

  populate_user: (user) ->
    view = new UserView model: user
    ($ '.side_content').html view.render().el
    
  populate_listings: (listings) ->
    listings_view = new ListingsView collection: listings
    ($ '#main_inner').html listings_view.render().el
    setTimeout =>
      ($ '#wrapper').removeClass 'transition'
    , 100

  populate_friends: (friends) ->
    view = new FriendsView collection: friends
    ($ '#main_inner').html view.render().el
    setTimeout =>
      ($ '#wrapper').removeClass 'transition'
    , 100

  populate_side_listings: (side_listings) ->
    view = new SideListingsView collection: side_listings
    ($ '.side_content').html view.render().el

  populate_create_button: (listings) ->
    view = new CreateButton collection: listings
    ($ '.side_create').html view.render().el

  populate_side: (options) ->
    view = new SortOptionsView(options)
    ($ ".sort_container").html view.render().el
    if options and options.active == "you"
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
    @fetch_user(username)
    @fetch_or_preload_user_listings(username)
    if oApp.currentUser && oApp.currentUser.username == username
      @populate_side(active: "you")
    else
      @populate_side(active: username)
    ($ '.side_create').html ''
   
  friends_feed: ->
    @fetch_or_preload_friends_feed_listings()
    @populate_side(active: "friends")

  find_friends: (username) ->
    @fetch_or_preload_find_friends()
    @fetch_user(username)
    @populate_side(active: "find_friends")

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
      