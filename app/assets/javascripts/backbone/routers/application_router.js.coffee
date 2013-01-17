window.ApplicationRouter = Backbone.Router.extend
  routes:
    "nyc" : "index"
    "/nyc" : "index"
    "friends" : "friends_feed"
    "/friends" : "friends_feed"
    "nyc/create" : "createListing"
    "friends/create" : "createListing"
    "listings/:id" : "permalink"
    "/listings/:id" : "permalink"
    "users/new" : "userCreate"
    "/users/new" : "userCreate"
    ":username/find_friends" : "find_friends"
    ":username" : "profile"
    "/:username" : "profile"

  fetch_or_preload_city_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings, side_listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      if oApp.currentUser
        @populate_create_button(listings)     
      @data_loaded = true
    else
      listings.fetch
        url: "/nyc"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings)
          if oApp.currentUser
            @populate_create_button(listings)

  fetch_or_preload_friends_feed_listings: ->
    listings = new Listings
    if preloaded_data? && !@data_loaded?
      listings.reset(preloaded_data)
      @populate_listings(listings)
      side_listings = new SideListings preloaded_data
      @populate_side_listings(side_listings)
      @populate_create_button(listings)
      findbutton = new FindFriends
      ($ '.side_content').prepend findbutton.render().el
      @data_loaded = true
    else
      listings.fetch
        url: "/friends.json"
        success: (listings, response) =>
          @populate_listings(listings)
          side_listings = new SideListings response
          @populate_side_listings(side_listings)
          @populate_create_button(listings)
          findbutton = new FindFriends
          ($ '.side_content').prepend findbutton.render().el
 
  fetch_or_preload_listing: (id) ->
    if preloaded_data? && !@data_loaded?
      listing = new Listing preloaded_data
      @populate_listing(listing)
      @data_loaded = true
    else
      listing = new Listing
      listing.fetch
        url: "/listings/#{id}"
        success: (listing, response) =>
          @populate_listing(listing)
 
  fetch_and_populate_side_listings: ->
    listings = new Listings
    listings.fetch
      url: "/nyc"
      success: (listings, response) =>
        side_listings = new SideListings response
        @populate_side_listings(side_listings)
 
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

  populate_user: (user) ->
    view = new UserView model: user
    ($ '.side_content').html view.render().el
    
  populate_listings: (listings, side_listings) ->
    listings_view = new ListingsView collection: listings
    window.main_listings = listings_view
    ($ '#main_inner').html listings_view.render().el
    setTimeout =>
      ($ '#wrapper').removeClass 'transition'
    , 100

  populate_listing: (listing) ->
    listing_view = new ListingView 
      model: listing, permalink: true
    ($ '#main_inner').html listing_view.render().el
    ($ '#main_inner').prepend '<div class="month_container"><div class="month">' + listing.getMonth() + '</div></div>'
    setTimeout =>
      ($ '#wrapper').removeClass 'transition'
    , 100
    
  populate_friends: (username) ->
    view = new FindFriendsView
    ($ '#main_inner').html view.render().el
    if preloaded_data? && !@data_loaded?
      users = new Users
      users.reset(preloaded_data)
      all_view = new FriendsView collection: users
      ($ '#main_inner .all').html all_view.render().el
      @data_loaded = true
    else
      users = new Users
      users.fetch
        url: "/#{username}/find_friends"
        success: (users, response) =>
          all_view = new FriendsView collection: users
          ($ '#main_inner .all').html all_view.render().el
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
    if options && options.active == "you"
      header = new ListingsHeader(active: oApp.currentUser.username)
    else
      header = new ListingsHeader(options)
    ($ '.listing_top').html header.render().el

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
  
  userCreate: ->
    ($ '#main_column').addClass('inactive')
    #Twitter special case, the only way you will get here
    data = {}
    data["tw_id"] = preloaded_data.uid
    data["username"] = preloaded_data.info.nickname
    data["image"] = preloaded_data.info.image
    data["description"] = preloaded_data.info.description
    data["tw_token"] = preloaded_data.info.tw_token
    user = new User data
    view = new UserNewView model: user
    ($ '#panel_container').html view.render().el
  
  permalink: (id) ->
    @fetch_or_preload_listing(id)
    @fetch_and_populate_side_listings()
    @populate_side()
    ($ '.side_create').html ''
   
  friends_feed: ->
    @fetch_or_preload_friends_feed_listings()
    @populate_side(active: "friends")

  find_friends: (username) ->
    @populate_friends()
    @populate_side(active: "find_friends")
    ($ '.side_create').html ''

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
      