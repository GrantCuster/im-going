window.ListingView = Backbone.View.extend
  template: JST["templates/listings/listing"]
  className: "listing"

  initialize: ->
    _.bindAll @, 'render'

  render: ->
    HTML = @template
      name: @model.getName()
      email: @model.getUser().getName()
    ($ @el).html HTML
    @

window.ListingsView = Backbone.View.extend
  className: "events_listing"
  template: JST["templates/listings/index"]
  events:
    "click #create_listing" : "showCreate"
  
  showCreate: ->
    listing_create = new ListingCreate @collection
    if ($ '.listing_create_container').length > 0
      ($ '.listing_create_container').replaceWith listing_create.render().el
    else
      ($ '.events_listing').prepend listing_create.render().el
    return false
  
  initialize: ->
    _.bindAll @, 'initSubViews', 'render'
    me = @
  
  initSubViews: ->
    me = @
    me.listing_views = []
    @collection.each (listing) ->
      me.listing_views.push new ListingView
        model: listing
    _.each(me.listing_views, (listing_view) ->      
      ($ me.el).append listing_view.render().el
    )

  render: ->
    me = @
    ($ @el).html @template
    @initSubViews()
    @

window.ListingCreate = Backbone.View.extend
  className: "listing_create_container"
  template: JST["templates/listings/new"]
  events:
    'click input[type="submit"]' : "createListing"
  
  initialize: (collection) ->
    _.bindAll @
    @collection = collection

  createListing: ->
    me = @
    data = {}
    data["listing_name"] = ($ "#listing_listing_name").val()
    data["user_id"] = currentUser.id
    @collection.create data
    return false

  render: ->
    ($ @el).html @template
    @