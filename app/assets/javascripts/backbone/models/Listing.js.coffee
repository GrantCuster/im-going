window.Listing = Backbone.Model.extend

  getID: -> @get "id"
  getName: -> @get "listing_name"
  getIntention: -> @get "intention"
  getDateTime: -> 
    d = new Date Date.parse(@get "date_and_time")
    d.toString()
  getDay: -> $.format.date(@getDateTime(),"ddd").substr(0,3)
  getDate: -> 
    date = $.format.date(@getDateTime(),"d")
    digit = date.charAt( date.length-1 )
    if digit == '1'
      date = date + 'st'
    else if digit == '2'
      date = date + 'nd'
    else if digit == '3'
      date = date + 'rd'
    else
      date = date + 'th'
    date
  getTime: -> 
    time = $.format.date(@getDateTime(),"ha").toString()
    time_stripped = time.replace("M", "")
    time_stripped
  getMonth: -> $.format.date(@getDateTime(),"MMMM")
  getFormDay: ->
    $.format.date(@getDateTime(), "ddd, MMMM dd")
  getFormTime: ->
    $.format.date(@getDateTime(), "h:mm a")
  getUser: -> @get "user"
  getUserID: -> @get "user_id"
  
  
  getTicketOption: -> @get "ticket_option"
  getIfMap: -> if @get "lat" then true else false
  getLat: -> 
    lat_raw = @get "lat"
    lat = lat_raw/1000000
    lat
  getLng: ->
    lng_raw = @get "lng"
    lng = lng_raw/1000000
    lng
  # getSellOut: -> 
  #   option_num = @get "sell_out"
  #   if option_num == 0
  #     days = 0
  #   else if option_num == 1
  #     days = 7
  #   else
  #     days = 30
  #   if !(days == "no_date")
  #     current_date = new Date
  #     sale_date = @getSaleDate()
  #     if sale_date
  #       d = new Date Date.parse(@getSaleDate())
  #     else
  #       d = new Date Date.parse(@get "created_at")
  #     d.setDate(d.getDate() + days)
  #     days_until = (d - current_date)/86400000
  #     if days_until < 2
  #       urgency = "red"
  #     else if days_until < 7
  #       urgency = "orange"
  #     else
  #       urgency = "green"
  #     urgency
  # getSaleDate: ->
  #   sale_date = @get "sale_date"
  #   sale_date
  # getSaleMonth: ->
  #   date = $.format.date(@getSaleDate(),"M")
  #   date
  # getSaleDay: ->
  #   date = $.format.date(@getSaleDate(),"d")
  #   date
  getCost: -> @get "cost"  
  getTicketUrl: -> @get "ticket_url"
  getUserID: -> @get "user_id"
  getIntentions: ->
    listing_intention = new Intention( intention: this.getIntention() + 1, user_id: this.getUserID(), user: this.getUser() )
    intentions = new Intentions([listing_intention])
    other_intentions = @get "intentions"
    intentions.add(other_intentions)
    intentions

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
  url: "/listings"
  comparator: (listing) -> 
    d = new Date Date.parse(listing.get("date_and_time"))
    (d.getTime())

window.SideListings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    0 - listing.getID()

  initialize: ->