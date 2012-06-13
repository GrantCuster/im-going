window.CommentView = Backbone.View.extend
  template: JST["templates/comments/comment"]
  className: "comment group"
  events: 
    "click .user_link" : "userLoad"
    "click .actions" : "deleteComment"
    
  initialize: ->
    _.bindAll @, 'render'
    
  userLoad: (e) ->
    username = @model.getUser().getName()
    unless window.location.pathname == "#{username}"
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate username, {trigger: true}
      , 100
    return false
  
  deleteComment: ->
    @model.destroy
      success: (model, response) =>
        ($ @el).slideUp 200, =>
          ($ @el).remove()
  
  render: ->
    user = @model.getUser()
    HTML = @template
      avatar: user.getImageURL()
      name: user.getName()
      text: @model.getComment()
      timestamp: @model.getDateTime()
      owner: if oApp.currentUser.id == user.getId() then true else false
    ($ @el).html HTML
    @

window.NewCommentView = Backbone.View.extend
  template: JST["templates/comments/new"]
  className: "comment group"
  events: 
    "focus textarea" : "active"
    "blur textarea" : "inactive"
    "click .post" : "saveComment"

  initialize: ->
    _.bindAll @, 'render'

  active: ->
    ($ @el).find('textarea').addClass 'active'
    ($ @el).find('.post').addClass 'active'

  inactive: ->
    if ($ @el).find('textarea').val().length == 0
      ($ @el).find('textarea').removeClass 'active'
      ($ @el).find('.post').removeClass 'active'
  
  saveComment: ->
    listing_id = @model.getListingId()
    text = ($ @el).find('textarea').val()
    data = {}
    data["listing_id"] = listing_id
    data["comment"] = text
    data["user_id"] = oApp.currentUser.id
    @collection.create data

  render: ->
    user = @model.getUser()
    HTML = @template
      avatar: user.getImageURL()
    ($ @el).html HTML
    @
 
window.CommentsView = Backbone.View.extend
  template: JST["templates/comments/comments"]
  className: "comments"
  
  initialize: (options) ->
    _.bindAll @, 'render'
    @collection.bind 'add', @render, @
    @collection.bind 'remove', @render, @
    @listing = options.listing
  
  initSubViews: ->
    me = @
    me.comment_views = []
    @collection.each (comment) ->
      me.comment_views.push new CommentView
        model: comment
    _.each(me.comment_views, (comment_view) ->    
      ($ me.el).append comment_view.render().el
    )
    if oApp.currentUser
      user = new User oApp.currentUser
      listing_id = @listing.getID()
      new_comment = new Comment user: user, listing_id: listing_id
      new_comment_view = new NewCommentView model: new_comment, collection: @collection
      ($ @el).append new_comment_view.render().el

  render: ->
    HTML = @template
    ($ @el).html HTML
    @initSubViews()
    @