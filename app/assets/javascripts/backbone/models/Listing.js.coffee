window.Listing = Backbone.Model.extend
  initialize: (options) ->
    @urlRoot = '/listings'

  getID: -> @get "id"
  getName: -> @get "listing_name"
  getDateTime: -> 
    d = new Date Date.parse(@get "date_and_time")
    d.toString()
  getDay: -> $.format.date(@getDateTime(),"ddd").substr(0,3)
  getDate: -> 
    date = $.format.date(@getDateTime(),"d")
    date
  getTime: -> 
    time = $.format.date(@getDateTime(),"ha").toString()
    time_stripped = time.replace("M", "")
    time_stripped
  getMonth: -> $.format.date(@getDateTime(),"MMMM")
  getUser: -> new User (@get "user")
  getShortDate: -> $.format.date(@getDateTime(),"M/d")

window.Listings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    d = new Date Date.parse(listing.get("date_and_time"))
    (d.getTime())

  initialize: ->

window.SideListings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    0 - listing.getID()

  initialize: ->