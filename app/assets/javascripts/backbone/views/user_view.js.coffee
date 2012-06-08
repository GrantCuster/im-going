window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"
  events:
    "click .follow" : "followUser"
    "click .find_friends" : "findFriends"

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

  findFriends: ->
    username = @model.getName()
    unless window.location.pathname == "/#{username}/find_friends"    
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate "#{username}/find_friends", {trigger: true}
      , 100

  render: ->
    HTML = @template
      name: @model.getName()
      image: @model.getImageURL()
      description: @model.getDescription()
      followed: @model.getFollowStatus()
      current_user: true if oApp.currentUser.id == @model.getId()
    ($ @el).html HTML
    @

window.FriendView = Backbone.View.extend
  template: JST["templates/users/friend"]
  className: "friend user_li"
  events: 
    "click .follow_status" : "followUp"

  initialize: ->
    _.bindAll @, 'render'
 
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
    ($ @el).html HTML
    @initSubViews()
    @