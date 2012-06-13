window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"
  events:
    "click .follow" : "followUser"

  initialize: ->
    _.bindAll @
    @model.bind 'change', @render, @

  followUser: (e) ->
    if ($ e.target).parents('.follow').hasClass 'un'
      relation = new Relationship @model.getFollowStatus()
      relation.destroy 
        success: (model, response) =>
          @model.set {followed_by_current_user: null}
          @render()
    else if ($ e.target).parents('.follow').hasClass 'edit'
      # get this out of here
      ($ '#main_column').addClass('inactive')
      view = new UserEditView model: @model
      ($ '#panel_container').html view.render().el
    else
      data = {}
      data["followed_id"] = @model.getId()
      data["follower_id"] = oApp.currentUser.id
      relation = new Relationship
      relation.save data,
        success: (model, response) =>
          @model.set {followed_by_current_user: response}
          @render()

  render: ->
    HTML = @template
      name: @model.getName()
      image: @model.getImageURL()
      description: @model.getDescription()
      followed: @model.getFollowStatus()
      current_user: true if oApp.currentUser.id == @model.getId()
    ($ @el).html HTML
    @

window.FindFriendsView = Backbone.View.extend
  template: JST["templates/find_friends_view"]
  className: "find_friends_container"
  events:
    "click .facebook" : "connectFacebook"
    "click .twitter" : "connectTwitter"
  
  initialize: ->
    _.bindAll @, 'render'
  
  connectFacebook: ->
    window.location = 'http://localhost:3000/users/auth/facebook'

  connectTwitter: ->
    window.location = 'http://localhost:3000/users/auth/twitter'
    
  initSubViews: ->
    if oApp.currentUser.tw_token
      friends = new Users
      friends.fetch
        url: "/#{oApp.currentUser.username}/find_twitter_friends.json"
        success: (friends, response) =>
          view = new FriendsView collection: friends
          ($ @el).find('.twitter_friends').html view.render().el
    if oApp.currentUser.fb_token
      console.log 'if passed'
      friends = new Users
      friends.fetch
        url: "/#{oApp.currentUser.username}/find_facebook_friends.json"
        success: (friends, response) =>
          view = new FriendsView collection: friends
          ($ @el).find('.facebook_friends').html view.render().el
  
  render: ->
    HTML = @template
      tw_connected: if oApp.currentUser.tw_token then true else false
      fb_connected: if oApp.currentUser.fb_token then true else false
    ($ @el).html HTML
    @initSubViews()
    @

window.FindFriends = Backbone.View.extend
  template: JST["templates/find_friends"]
  className: "find_friends side_button"
  events:
    "click" : "findFriends"
  
  initialize: ->
    _.bindAll @, 'render'

  findFriends: ->
    username = oApp.currentUser.username
    unless window.location.pathname == "/#{username}/find_friends"    
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate "#{username}/find_friends", {trigger: true}
      , 100
  
  render: ->
    HTML = @template
    ($ @el).html HTML
    @

window.FriendView = Backbone.View.extend
  template: JST["templates/users/friend"]
  className: "friend user_li"
  events: 
    "click .follow_status" : "followUp"
    "click .user_name" : "loadUser"

  initialize: ->
    console.log 'friend view'
    _.bindAll @, 'render'
 
  loadUser: ->
    username = @model.getName()
    ($ '#wrapper').addClass 'transition'
    setTimeout =>
      window.router.navigate username, {trigger: true}
    , 100
    return false
 
  followUp: (e) ->
    $target = ($ @el).find('.follow_status')
    if $target.hasClass 'following'
      relation = new Relationship @model.getFollowStatus()
      relation.destroy 
        success: (model, response) =>
          @model.set {followed_by_current_user: null}
          @render()
    else
      data = {}
      data["followed_id"] = @model.getId()
      data["follower_id"] = oApp.currentUser.id
      relation = new Relationship
      relation.save data,
        success: (model, response) =>
          @model.set {followed_by_current_user: response}
          @render()

  render: ->
    console.log @model
    HTML = @template
      name: @model.getName()
      followed: @model.getFollowStatus()
    ($ @el).html HTML
    @

window.FriendsView = Backbone.View.extend
  className: "friends_list users_list"
  template: JST["templates/users/friends"]

  initialize: ->
    _.bindAll @, 'initSubViews', 'render'

  initSubViews: ->
    me = @
    me.friend_views = []
    @collection.each (friend) =>
      me.friend_views.push new FriendView(model: friend)
    _.each(me.friend_views, (friend_view) =>   
      ($ @el).append friend_view.render().el
    )

  render: ->
    me = @
    HTML = @template
      empty: if @collection.length == 0 then true else false
    ($ @el).html HTML
    @initSubViews()
    @