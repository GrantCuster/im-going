window.Listing = Backbone.Model.extend
  initialize: (options) ->
    @urlRoot = '/listings'

  getID: -> @get "id"
  getName: -> @get "listing_name"
  getIntention: -> 
    intent_num = @get "intention"
    if intent_num == 0
      intention = "is going"
    else if intent_num == 1
      intention = "is thinking about going to"
    else
      intention = "would go, if someone else does, to"
    intention
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
  getUser: -> @get "user"
  getUsername: ->
    user = @getUser()
    console.log 'user'
    console.log user
    return false
  getTicketOption: -> @get "ticket_option"  
  getSellOut: -> 
    option_num = @get "sell_out"
    if option_num == 0
      days = 0
    else if option_num == 1
      days = 7
    else
      days = 30
    if !(days == "no_date")
      current_date = new Date
      sale_date = @getSaleDate()
      console.log sale_date
      if sale_date
        d = new Date Date.parse(@getSaleDate())
      else
        d = new Date Date.parse(@get "created_at")
      d.setDate(d.getDate() + days)
      console.log d.toString()
      days_until = (d - current_date)/86400000
      if days_until < 2
        urgency = "red"
      else if days_until < 7
        urgency = "orange"
      else
        urgency = "green"
      urgency
  getSaleDate: ->
    sale_date = @get "sale_date"
    sale_date
  getSaleMonth: ->
    date = $.format.date(@getSaleDate(),"M")
    date
  getSaleDay: ->
    date = $.format.date(@getSaleDate(),"d")
    date
  getCost: -> @get "cost"  
  getTicketUrl: -> @get "ticket_url"
  getUserID: -> @get "user_id"
  getIntentions: -> new Intentions(@get "intentions")

  # getTicketDate: () ->
  #   n = getSellOut()
  #   d = new Date Date.parse(@get "date_and_time")
  #   new_d = d.setDate(d.getDate() + n)
  #   d.toString()
  # getTicketMonth: -> $.format.date(@getTicketDate(),"MM")
  # getTicketDay: -> $.format.date(@getTicketDate(),"dd")
  getVenueName: -> @get "venue_name"
  getVenueAddress: -> @get "venue_address"
  getVenueUrl: -> @get "venue_url"
  getEventDescription: -> @get "event_description"
  getShortDate: -> $.format.date(@getDateTime(),"M/d")

window.Listings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    d = new Date Date.parse(listing.get("date_and_time"))
    (d.getTime())

window.SideListings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    0 - listing.getID()

  initialize: ->