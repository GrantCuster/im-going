window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"
  events:
    "click .follow" : "followUser"

  initialize: ->
    _.bindAll @
    console.log @model

  followUser: (e) ->
    if ($ e.target).parents('.follow').hasClass 'un'
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
      image: @model.getImageURL()
      description: @model.getDescription()
      followed: @model.getFollowStatus()
    ($ @el).html HTML
    @

window.FriendView = Backbone.View.extend
  template: JST["templates/users/friend"]
  className: "friend"

  initialize: ->
    _.bindAll @, 'render'

  render: ->
    HTML = @template
      name: @model.getName()
    ($ @el).html HTML
    @

window.FriendsView = Backbone.View.extend
  className: "friends_list"
  template: JST["templates/users/friends"]

  initialize: ->
    _.bindAll @, 'initSubViews', 'render'

  addOne: (listing) ->
    window.side_listings.add(listing)
    @render()

  initSubViews: ->
    me = @
    me.friend_views = []
    @collection.each (friend) ->
      me.friend_views.push new FriendView
        model: friend
    _.each(me.friend_views, (friend_view) ->    
      ($ me.el).append friend_view.render().el
    )

  render: ->
    me = @
    HTML = @template
    ($ @el).html HTML
    @initSubViews()
    @